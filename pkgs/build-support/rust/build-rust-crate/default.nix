# Code for buildRustCrate, a Nix function that builds Rust code, just
# like Cargo, but using Nix instead.
#
# This can be useful for deploying packages with NixOps, and to share
# binary dependencies between projects.

{ lib, stdenv, defaultCrateOverrides, fetchCrate, rustc, rust }:

let
    # This doesn't appear to be officially documented anywhere yet.
    # See https://github.com/rust-lang-nursery/rust-forge/issues/101.
    target_os = if stdenv.hostPlatform.isDarwin
      then "macos"
      else stdenv.hostPlatform.parsed.kernel.name;

    # Create rustc arguments to link against the given list of dependencies and
    # renames
    mkRustcDepArgs = dependencies: crateRenames:
      lib.concatMapStringsSep " " (dep:
        let
          extern = lib.replaceStrings ["-"] ["_"] dep.libName;
          name = if lib.hasAttr dep.crateName crateRenames then
            lib.strings.replaceStrings ["-"] ["_"] crateRenames.${dep.crateName}
          else
            extern;
        in (if lib.any (x: x == "lib") dep.crateType then
           " --extern ${name}=${dep.lib}/lib/lib${extern}-${dep.metadata}.rlib"
         else
           " --extern ${name}=${dep.lib}/lib/lib${extern}-${dep.metadata}${stdenv.hostPlatform.extensions.sharedLibrary}")
      ) dependencies;

   inherit (import ./log.nix { inherit lib; }) noisily echo_build_heading;

   configureCrate = import ./configure-crate.nix {
     inherit lib stdenv echo_build_heading noisily mkRustcDepArgs;
   };

   buildCrate = import ./build-crate.nix {
     inherit lib stdenv echo_build_heading noisily mkRustcDepArgs rust;
   };

   installCrate = import ./install-crate.nix { inherit stdenv; };
in

crate_: lib.makeOverridable ({ rust, release, verbose, features, buildInputs, crateOverrides,
  dependencies, buildDependencies, crateRenames,
  extraRustcOpts, buildTests,
  preUnpack, postUnpack, prePatch, patches, postPatch,
  preConfigure, postConfigure, preBuild, postBuild, preInstall, postInstall }:

let crate = crate_ // (lib.attrByPath [ crate_.crateName ] (attr: {}) crateOverrides crate_);
    dependencies_ = dependencies;
    buildDependencies_ = buildDependencies;
    processedAttrs = [
      "src" "buildInputs" "crateBin" "crateLib" "libName" "libPath"
      "buildDependencies" "dependencies" "features" "crateRenames"
      "crateName" "version" "build" "authors" "colors" "edition"
      "buildTests"
    ];
    extraDerivationAttrs = builtins.removeAttrs crate processedAttrs;
    buildInputs_ = buildInputs;
    extraRustcOpts_ = extraRustcOpts;
    buildTests_ = buildTests;

    # take a list of crates that we depend on and override them to fit our overrides, rustc, release, …
    makeDependencies = map (dep: lib.getLib (dep.override { inherit release verbose crateOverrides; }));

    # crate2nix has a hack for the old bash based build script that did split
    # entries at `,`. No we have to work around that hack.
    # https://github.com/kolloch/crate2nix/blame/5b19c1b14e1b0e5522c3e44e300d0b332dc939e7/crate2nix/templates/build.nix.tera#L89
    crateBin = lib.filter (bin: !(bin ? name && bin.name == ",")) (crate.crateBin or []);
    hasCrateBin = crate ? crateBin;
in
stdenv.mkDerivation (rec {

    inherit (crate) crateName;
    inherit
      preUnpack
      postUnpack
      prePatch
      patches
      postPatch
      preConfigure
      postConfigure
      preBuild
      postBuild
      preInstall
      postInstall
      buildTests
    ;

    src = crate.src or (fetchCrate { inherit (crate) crateName version sha256; });
    name = "rust_${crate.crateName}-${crate.version}${lib.optionalString buildTests_ "-test"}";
    depsBuildBuild = [ rust stdenv.cc ];
    buildInputs = (crate.buildInputs or []) ++ buildInputs_;
    dependencies = makeDependencies dependencies_;
    buildDependencies = makeDependencies buildDependencies_;

    completeDeps = lib.unique (dependencies ++ lib.concatMap (dep: dep.completeDeps) dependencies);
    completeBuildDeps = lib.unique (
      buildDependencies
      ++ lib.concatMap (dep: dep.completeBuildDeps ++ dep.completeDeps) buildDependencies
    );

    crateFeatures = lib.optionalString (crate ? features)
      (lib.concatMapStringsSep " " (f: "--cfg feature=\\\"${f}\\\"") (crate.features ++ features));

    libName = if crate ? libName then crate.libName else crate.crateName;
    libPath = if crate ? libPath then crate.libPath else "";

    # Seed the symbol hashes with something unique every time.
    # https://doc.rust-lang.org/1.0.0/rustc/metadata/loader/index.html#frobbing-symbols
    metadata = let
      depsMetadata = lib.foldl' (str: dep: str + dep.metadata) "" (dependencies ++ buildDependencies);
      hashedMetadata = builtins.hashString "sha256"
        (crateName + "-" + crateVersion + "___" + toString crateFeatures + "___" + depsMetadata);
      in lib.substring 0 10 hashedMetadata;

    build = crate.build or "";
    workspace_member = crate.workspace_member or ".";
    crateVersion = crate.version;
    crateDescription = crate.description or "";
    crateAuthors = if crate ? authors && lib.isList crate.authors then crate.authors else [];
    crateHomepage = crate.homepage or "";
    crateType =
      if lib.attrByPath ["procMacro"] false crate then ["proc-macro"] else
      if lib.attrByPath ["plugin"] false crate then ["dylib"] else
        (crate.type or ["lib"]);
    colors = lib.attrByPath [ "colors" ] "always" crate;
    extraLinkFlags = lib.concatStringsSep " " (crate.extraLinkFlags or []);
    edition = crate.edition or null;
    extraRustcOpts =
      lib.optionals (crate ? extraRustcOpts) crate.extraRustcOpts
      ++ extraRustcOpts_
      ++ (lib.optional (edition != null) "--edition ${edition}");


    configurePhase = configureCrate {
      inherit crateName buildDependencies completeDeps completeBuildDeps crateDescription
              crateFeatures crateRenames libName build workspace_member release libPath crateVersion
              extraLinkFlags extraRustcOpts
              crateAuthors crateHomepage verbose colors target_os;
    };
    buildPhase = buildCrate {
      inherit crateName dependencies
              crateFeatures crateRenames libName release libPath crateType
              metadata hasCrateBin crateBin verbose colors
              extraRustcOpts buildTests;
    };
    installPhase = installCrate crateName metadata buildTests;

    # depending on the test setting we are either producing something with bins
    # and libs or just test binaries
    outputs = if buildTests then [ "out" ] else [ "out" "lib" ];
    outputDev = if buildTests then [ "out" ] else  [ "lib" ];

} // extraDerivationAttrs
)) {
  rust = rustc;
  release = crate_.release or true;
  verbose = crate_.verbose or true;
  extraRustcOpts = [];
  features = [];
  buildInputs = [];
  crateOverrides = defaultCrateOverrides;
  preUnpack = crate_.preUnpack or "";
  postUnpack = crate_.postUnpack or "";
  prePatch = crate_.prePatch or "";
  patches = crate_.patches or [];
  postPatch = crate_.postPatch or "";
  preConfigure = crate_.preConfigure or "";
  postConfigure = crate_.postConfigure or "";
  preBuild = crate_.preBuild or "";
  postBuild = crate_.postBuild or "";
  preInstall = crate_.preInstall or "";
  postInstall = crate_.postInstall or "";
  dependencies = crate_.dependencies or [];
  buildDependencies = crate_.buildDependencies or [];
  crateRenames = crate_.crateRenames or {};
  buildTests = crate_.buildTests or false;
}
