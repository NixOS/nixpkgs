# Code for buildRustCrate, a Nix function that builds Rust code, just
# like Cargo, but using Nix instead.
#
# This can be useful for deploying packages with NixOps, and to share
# binary dependencies between projects.

{ lib, stdenv, defaultCrateOverrides, fetchCrate, rustc }:

let
    # This doesn't appear to be officially documented anywhere yet.
    # See https://github.com/rust-lang-nursery/rust-forge/issues/101.
    target_os = if stdenv.hostPlatform.isDarwin
      then "macos"
      else stdenv.hostPlatform.parsed.kernel.name;

    makeDeps = dependencies:
      (lib.concatMapStringsSep " " (dep:
        let extern = lib.strings.replaceStrings ["-"] ["_"] dep.libName; in
        (if lib.lists.any (x: x == "lib") dep.crateType then
           " --extern ${extern}=${dep.out}/lib/lib${extern}-${dep.metadata}.rlib"
         else
           " --extern ${extern}=${dep.out}/lib/lib${extern}-${dep.metadata}${stdenv.hostPlatform.extensions.sharedLibrary}")
      ) dependencies);

    echo_build_heading = colors: ''
      echo_build_heading() {
       start=""
       end=""
       if [[ "${colors}" == "always" ]]; then
         start="$(printf '\033[0;1;32m')" #set bold, and set green.
         end="$(printf '\033[0m')" #returns to "normal"
       fi
       if (( $# == 1 )); then
         echo "$start""Building $1""$end"
       else
         echo "$start""Building $1 ($2)""$end"
       fi
      }
    '';
    noisily = colors: verbose: ''
      noisily() {
        start=""
        end=""
        if [[ "${colors}" == "always" ]]; then
          start="$(printf '\033[0;1;32m')" #set bold, and set green.
          end="$(printf '\033[0m')" #returns to "normal"
        fi
	${lib.optionalString verbose ''
            echo -n "$start"Running "$end"
            echo $@
	''}
	$@
      }
    '';

    configureCrate = import ./configure-crate.nix { inherit lib stdenv echo_build_heading noisily makeDeps; };
    buildCrate = import ./build-crate.nix { inherit lib stdenv echo_build_heading noisily makeDeps; };
    installCrate = import ./install-crate.nix;

    in

crate_: lib.makeOverridable ({ rust, release, verbose, features, buildInputs, crateOverrides,
  dependencies, buildDependencies,
  extraRustcOpts,
  preUnpack, postUnpack, prePatch, patches, postPatch,
  preConfigure, postConfigure, preBuild, postBuild, preInstall, postInstall }:

let crate = crate_ // (lib.attrByPath [ crate_.crateName ] (attr: {}) crateOverrides crate_);
    dependencies_ = dependencies;
    buildDependencies_ = buildDependencies;
    processedAttrs = [
      "src" "buildInputs" "crateBin" "crateLib" "libName" "libPath"
      "buildDependencies" "dependencies" "features"
      "crateName" "version" "build" "authors" "colors" "edition"
    ];
    extraDerivationAttrs = lib.filterAttrs (n: v: ! lib.elem n processedAttrs) crate;
    buildInputs_ = buildInputs;
    extraRustcOpts_ = extraRustcOpts;
in
stdenv.mkDerivation (rec {

    inherit (crate) crateName;
    inherit preUnpack postUnpack prePatch patches postPatch preConfigure postConfigure preBuild postBuild preInstall postInstall;

    src = if lib.hasAttr "src" crate then
        crate.src
      else
        fetchCrate { inherit (crate) crateName version sha256; };
    name = "rust_${crate.crateName}-${crate.version}";
    depsBuildBuild = [ rust stdenv.cc ];
    buildInputs = (crate.buildInputs or []) ++ buildInputs_;
    dependencies =
      builtins.map
        (dep: dep.override { rust = rust; release = release; verbose = verbose; crateOverrides = crateOverrides; })
        dependencies_;

    buildDependencies =
      builtins.map
        (dep: dep.override { rust = rust; release = release; verbose = verbose; crateOverrides = crateOverrides; })
        buildDependencies_;

    completeDeps = lib.lists.unique (dependencies ++ lib.lists.concatMap (dep: dep.completeDeps) dependencies);
    completeBuildDeps = lib.lists.unique (
      buildDependencies
      ++ lib.lists.concatMap (dep: dep.completeBuildDeps ++ dep.completeDeps) buildDependencies
    );

    crateFeatures = if crate ? features then
        lib.concatMapStringsSep " " (f: "--cfg feature=\\\"${f}\\\"") (crate.features ++ features) #"
      else "";

    libName = if crate ? libName then crate.libName else crate.crateName;
    libPath = if crate ? libPath then crate.libPath else "";

    depsMetadata = builtins.foldl' (str: dep: str + dep.metadata) "" (dependencies ++ buildDependencies);
    metadata = builtins.substring 0 10 (builtins.hashString "sha256" (crateName + "-" + crateVersion + "___" + toString crateFeatures + "___" + depsMetadata ));

    crateBin = if crate ? crateBin then
       builtins.foldl' (bins: bin: let
            name = (if bin ? name then bin.name else crateName);
            path = if bin ? path then bin.path else "";
          in
          bins + (if bin == "" then "" else ",") + "${name} ${path}"

       ) "" crate.crateBin
    else "";
    hasCrateBin = crate ? crateBin;

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
    extraLinkFlags = builtins.concatStringsSep " " (crate.extraLinkFlags or []);
    edition = crate.edition or null;
    extraRustcOpts = (if crate ? extraRustcOpts then crate.extraRustcOpts else []) ++ extraRustcOpts_ ++ (lib.optional (edition != null) "--edition ${edition}");

    configurePhase = configureCrate {
      inherit crateName buildDependencies completeDeps completeBuildDeps crateDescription
              crateFeatures libName build workspace_member release libPath crateVersion
              extraLinkFlags extraRustcOpts
              crateAuthors crateHomepage verbose colors target_os;
    };
    buildPhase = buildCrate {
      inherit crateName dependencies
              crateFeatures libName release libPath crateType
              metadata crateBin hasCrateBin verbose colors
              extraRustcOpts;
    };
    installPhase = installCrate crateName metadata;

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
}
