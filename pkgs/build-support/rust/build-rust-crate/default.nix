# Code for buildRustCrate, a Nix function that builds Rust code, just
# like Cargo, but using Nix instead.
#
# This can be useful for deploying packages with NixOps, and to share
# binary dependencies between projects.

{ lib, stdenv, defaultCrateOverrides, fetchCrate, rustc, rust, cargo, jq }:

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
        in (if lib.any (x: x == "lib" || x == "rlib") dep.crateType then
           " --extern ${name}=${dep.lib}/lib/lib${extern}-${dep.metadata}.rlib"
         else
           " --extern ${name}=${dep.lib}/lib/lib${extern}-${dep.metadata}${stdenv.hostPlatform.extensions.sharedLibrary}")
      ) dependencies;

   inherit (import ./log.nix { inherit lib; }) noisily echo_colored;

   configureCrate = import ./configure-crate.nix {
     inherit lib stdenv echo_colored noisily mkRustcDepArgs;
   };

   buildCrate = import ./build-crate.nix {
     inherit lib stdenv mkRustcDepArgs rust;
   };

   installCrate = import ./install-crate.nix { inherit stdenv; };
in

/* The overridable pkgs.buildRustCrate function.
 *
 * Any unrecognized parameters will be passed as to
 * the underlying stdenv.mkDerivation.
 */
 crate_: lib.makeOverridable (
   # The rust compiler to use.
   #
   # Default: pkgs.rustc
   { rust
   # Whether to build a release version (`true`) or a debug
   # version (`false`). Debug versions are faster to build
   # but might be much slower at runtime.
   , release
   # Whether to print rustc invocations etc.
   #
   # Example: false
   # Default: true
   , verbose
   # A list of rust/cargo features to enable while building the crate.
   # Example: [ "std" "async" ]
   , features
   # Additional build inputs for building this crate.
   #
   # Example: [ pkgs.openssl ]
   , buildInputs
   # Allows to override the parameters to buildRustCrate
   # for any rust dependency in the transitive build tree.
   #
   # Default: pkgs.defaultCrateOverrides
   #
   # Example:
   #
   # pkgs.defaultCrateOverrides // {
   #   hello = attrs: { buildInputs = [ openssl ]; };
   # }
   , crateOverrides
   # Rust library dependencies, i.e. other libaries that were built
   # with buildRustCrate.
   , dependencies
   # Rust build dependencies, i.e. other libaries that were built
   # with buildRustCrate and are used by a build script.
   , buildDependencies
   # Specify the "extern" name of a library if it differs from the library target.
   # See above for an extended explanation.
   #
   # Default: no renames.
   #
   # Example:
   #
   # ```nix
   # {
   #   my_crate_name = "my_alternative_name";
   #   # ...
   # }
   # ```
   , crateRenames
   # A list of extra options to pass to rustc.
   #
   # Example: [ "-Z debuginfo=2" ]
   # Default: []
   , extraRustcOpts
   # Whether to enable building tests.
   # Use true to enable.
   # Default: false
   , buildTests
   # Passed to stdenv.mkDerivation.
   , preUnpack
   # Passed to stdenv.mkDerivation.
   , postUnpack
   # Passed to stdenv.mkDerivation.
   , prePatch
   # Passed to stdenv.mkDerivation.
   , patches
   # Passed to stdenv.mkDerivation.
   , postPatch
   # Passed to stdenv.mkDerivation.
   , preConfigure
   # Passed to stdenv.mkDerivation.
   , postConfigure
   # Passed to stdenv.mkDerivation.
   , preBuild
   # Passed to stdenv.mkDerivation.
   , postBuild
   # Passed to stdenv.mkDerivation.
   , preInstall
   # Passed to stdenv.mkDerivation.
   , postInstall
   }:

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
    depsBuildBuild = [ rust stdenv.cc cargo jq ];
    buildInputs = (crate.buildInputs or []) ++ buildInputs_;
    dependencies = map lib.getLib dependencies_;
    buildDependencies = map lib.getLib buildDependencies_;

    completeDeps = lib.unique (dependencies ++ lib.concatMap (dep: dep.completeDeps) dependencies);
    completeBuildDeps = lib.unique (
      buildDependencies
      ++ lib.concatMap (dep: dep.completeBuildDeps ++ dep.completeDeps) buildDependencies
    );

    crateFeatures = lib.optionalString (crate ? features)
      (lib.concatMapStringsSep " " (f: ''--cfg feature=\"${f}\"'') (crate.features ++ features));

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
    # Either set to a concrete sub path to the crate root
    # or use `null` for auto-detect.
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
