# Code for buildRustCrate, a Nix function that builds Rust code, just
# like Cargo, but using Nix instead.
#
# This can be useful for deploying packages with NixOps, and to share
# binary dependencies between projects.

{ lib
, stdenv
, defaultCrateOverrides
, fetchCrate
, pkgsBuildBuild
, rustc
, rust
, cargo
, jq
, libiconv
}:

let
  # Create rustc arguments to link against the given list of dependencies
  # and renames.
  #
  # See docs for crateRenames below.
  mkRustcDepArgs = dependencies: crateRenames:
    lib.concatMapStringsSep " "
      (dep:
        let
          normalizeName = lib.replaceStrings [ "-" ] [ "_" ];
          extern = normalizeName dep.libName;
          # Find a choice that matches in name and optionally version.
          findMatchOrUseExtern = choices:
            lib.findFirst
              (choice:
                (!(choice ? version)
                  || choice.version == dep.version or ""))
              { rename = extern; }
              choices;
          name =
            if lib.hasAttr dep.crateName crateRenames then
              let choices = crateRenames.${dep.crateName};
              in
              normalizeName (
                if builtins.isList choices
                then (findMatchOrUseExtern choices).rename
                else choices
              )
            else
              extern;
          opts = lib.optionalString (dep.stdlib or false) "noprelude:";
          filename =
            if lib.any (x: x == "lib" || x == "rlib") dep.crateType
            then "${dep.metadata}.rlib"
            else "${dep.metadata}${stdenv.hostPlatform.extensions.sharedLibrary}";
        in
        " --extern ${opts}${name}=${dep.lib}/lib/lib${extern}-${filename}"
      )
      dependencies;

  # Create feature arguments for rustc.
  mkRustcFeatureArgs = lib.concatMapStringsSep " " (f: ''--cfg feature=\"${f}\"'');

  # Whether we need to use unstable command line flags
  #
  # Currently just needed for standard library dependencies, which have a
  # special "noprelude:" modifier. If in later versions of Rust this is
  # stabilized we can account for that here, too, so we don't opt into
  # instability unnecessarily.
  needUnstableCLI = dependencies:
    lib.any (dep: dep.stdlib or false) dependencies;

  inherit (import ./log.nix { inherit lib; }) noisily echo_colored;

  configureCrate = import ./configure-crate.nix {
    inherit lib stdenv rust echo_colored noisily mkRustcDepArgs mkRustcFeatureArgs;
  };

  buildCrate = import ./build-crate.nix {
    inherit lib stdenv mkRustcDepArgs mkRustcFeatureArgs needUnstableCLI rust;
  };

  installCrate = import ./install-crate.nix { inherit stdenv; };

  # Allow access to the rust attribute set from inside buildRustCrate, which
  # has a parameter that shadows the name.
  rustAttrs = rust;
in

  /* The overridable pkgs.buildRustCrate function.
    *
    * Any unrecognized parameters will be passed as to
    * the underlying stdenv.mkDerivation.
  */
crate_: lib.makeOverridable
  (
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
      # Additional native build inputs for building this crate.
    , nativeBuildInputs
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
      # `crateRenames` supports two formats.
      #
      # The simple version is an attrset that maps the
      # `crateName`s of the dependencies to their alternative
      # names.
      #
      # ```nix
      # {
      #   my_crate_name = "my_alternative_name";
      #   # ...
      # }
      # ```
      #
      # The extended version is also keyed by the `crateName`s but allows
      # different names for different crate versions:
      #
      # ```nix
      # {
      #   my_crate_name = [
      #       { version = "1.2.3"; rename = "my_alternative_name01"; }
      #       { version = "3.2.3"; rename = "my_alternative_name03"; }
      #   ]
      #   # ...
      # }
      # ```
      #
      # This roughly corresponds to the following snippet in Cargo.toml:
      #
      # ```toml
      # [dependencies]
      # my_alternative_name01 = { package = "my_crate_name", version = "0.1" }
      # my_alternative_name03 = { package = "my_crate_name", version = "0.3" }
      # ```
      #
      # Dependencies which use the lib target name as extern name, do not need
      # to be specified in the crateRenames, even if their crate name differs.
      #
      # Including multiple versions of a crate is very popular during
      # ecosystem transitions, e.g. from futures 0.1 to futures 0.3.
    , crateRenames
      # A list of extra options to pass to rustc.
      #
      # Example: [ "-Z debuginfo=2" ]
      # Default: []
    , extraRustcOpts
      # A list of extra options to pass to rustc when building a build.rs.
      #
      # Example: [ "-Z debuginfo=2" ]
      # Default: []
    , extraRustcOptsForBuildRs
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

    let
      crate = crate_ // (lib.attrByPath [ crate_.crateName ] (attr: { }) crateOverrides crate_);
      dependencies_ = dependencies;
      buildDependencies_ = buildDependencies;
      processedAttrs = [
        "src"
        "nativeBuildInputs"
        "buildInputs"
        "crateBin"
        "crateLib"
        "libName"
        "libPath"
        "buildDependencies"
        "dependencies"
        "features"
        "crateRenames"
        "crateName"
        "version"
        "build"
        "authors"
        "colors"
        "edition"
        "buildTests"
        "codegenUnits"
      ];
      extraDerivationAttrs = builtins.removeAttrs crate processedAttrs;
      nativeBuildInputs_ = nativeBuildInputs;
      buildInputs_ = buildInputs;
      extraRustcOpts_ = extraRustcOpts;
      extraRustcOptsForBuildRs_ = extraRustcOptsForBuildRs;
      buildTests_ = buildTests;

      # crate2nix has a hack for the old bash based build script that did split
      # entries at `,`. No we have to work around that hack.
      # https://github.com/kolloch/crate2nix/blame/5b19c1b14e1b0e5522c3e44e300d0b332dc939e7/crate2nix/templates/build.nix.tera#L89
      crateBin = lib.filter (bin: !(bin ? name && bin.name == ",")) (crate.crateBin or [ ]);
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
      version = crate.version;
      depsBuildBuild = [ pkgsBuildBuild.stdenv.cc ];
      nativeBuildInputs = [ rust stdenv.cc cargo jq ]
        ++ lib.optionals stdenv.buildPlatform.isDarwin [ libiconv ]
        ++ (crate.nativeBuildInputs or [ ]) ++ nativeBuildInputs_;
      buildInputs = lib.optionals stdenv.isDarwin [ libiconv ] ++ (crate.buildInputs or [ ]) ++ buildInputs_;
      dependencies = map lib.getLib dependencies_;
      buildDependencies = map lib.getLib buildDependencies_;

      completeDeps = lib.unique (dependencies ++ lib.concatMap (dep: dep.completeDeps) dependencies);
      completeBuildDeps = lib.unique (
        buildDependencies
          ++ lib.concatMap (dep: dep.completeBuildDeps ++ dep.completeDeps) buildDependencies
      );

      # Create a list of features that are enabled by the crate itself and
      # through the features argument of buildRustCrate. Exclude features
      # with a forward slash, since they are passed through to dependencies,
      # and dep: features, since they're internal-only and do nothing except
      # enable optional dependencies.
      crateFeatures = lib.optionals (crate ? features)
        (builtins.filter
          (f: !(lib.hasInfix "/" f || lib.hasPrefix "dep:" f))
          (crate.features ++ features)
        );

      libName = if crate ? libName then crate.libName else crate.crateName;
      libPath = lib.optionalString (crate ? libPath) crate.libPath;

      # Seed the symbol hashes with something unique every time.
      # https://doc.rust-lang.org/1.0.0/rustc/metadata/loader/index.html#frobbing-symbols
      metadata =
        let
          depsMetadata = lib.foldl' (str: dep: str + dep.metadata) "" (dependencies ++ buildDependencies);
          hashedMetadata = builtins.hashString "sha256"
            (crateName + "-" + crateVersion + "___" + toString (mkRustcFeatureArgs crateFeatures) +
              "___" + depsMetadata + "___" + rustAttrs.toRustTarget stdenv.hostPlatform);
        in
        lib.substring 0 10 hashedMetadata;

      build = crate.build or "";
      # Either set to a concrete sub path to the crate root
      # or use `null` for auto-detect.
      workspace_member = crate.workspace_member or ".";
      crateVersion = crate.version;
      crateDescription = crate.description or "";
      crateAuthors = if crate ? authors && lib.isList crate.authors then crate.authors else [ ];
      crateHomepage = crate.homepage or "";
      crateType =
        if lib.attrByPath [ "procMacro" ] false crate then [ "proc-macro" ] else
        if lib.attrByPath [ "plugin" ] false crate then [ "dylib" ] else
        (crate.type or [ "lib" ]);
      colors = lib.attrByPath [ "colors" ] "always" crate;
      extraLinkFlags = lib.concatStringsSep " " (crate.extraLinkFlags or [ ]);
      edition = crate.edition or null;
      codegenUnits = if crate ? codegenUnits then crate.codegenUnits else 1;
      extraRustcOpts =
        lib.optionals (crate ? extraRustcOpts) crate.extraRustcOpts
          ++ extraRustcOpts_
          ++ (lib.optional (edition != null) "--edition ${edition}");
      extraRustcOptsForBuildRs =
        lib.optionals (crate ? extraRustcOptsForBuildRs) crate.extraRustcOptsForBuildRs
        ++ extraRustcOptsForBuildRs_
        ++ (lib.optional (edition != null) "--edition ${edition}");


      configurePhase = configureCrate {
        inherit crateName buildDependencies completeDeps completeBuildDeps crateDescription
          crateFeatures crateRenames libName build workspace_member release libPath crateVersion
          extraLinkFlags extraRustcOptsForBuildRs
          crateAuthors crateHomepage verbose colors codegenUnits;
      };
      buildPhase = buildCrate {
        inherit crateName dependencies
          crateFeatures crateRenames libName release libPath crateType
          metadata hasCrateBin crateBin verbose colors
          extraRustcOpts buildTests codegenUnits;
      };
      dontStrip = !release;
      installPhase = installCrate crateName metadata buildTests;

      # depending on the test setting we are either producing something with bins
      # and libs or just test binaries
      outputs = if buildTests then [ "out" ] else [ "out" "lib" ];
      outputDev = if buildTests then [ "out" ] else [ "lib" ];

      meta = {
        mainProgram = crateName;
      };
    } // extraDerivationAttrs
    )
  )
{
  rust = rustc;
  release = crate_.release or true;
  verbose = crate_.verbose or true;
  extraRustcOpts = [ ];
  extraRustcOptsForBuildRs = [ ];
  features = [ ];
  nativeBuildInputs = [ ];
  buildInputs = [ ];
  crateOverrides = defaultCrateOverrides;
  preUnpack = crate_.preUnpack or "";
  postUnpack = crate_.postUnpack or "";
  prePatch = crate_.prePatch or "";
  patches = crate_.patches or [ ];
  postPatch = crate_.postPatch or "";
  preConfigure = crate_.preConfigure or "";
  postConfigure = crate_.postConfigure or "";
  preBuild = crate_.preBuild or "";
  postBuild = crate_.postBuild or "";
  preInstall = crate_.preInstall or "";
  postInstall = crate_.postInstall or "";
  dependencies = crate_.dependencies or [ ];
  buildDependencies = crate_.buildDependencies or [ ];
  crateRenames = crate_.crateRenames or { };
  buildTests = crate_.buildTests or false;
}
