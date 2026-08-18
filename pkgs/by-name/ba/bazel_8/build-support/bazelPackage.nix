{
  callPackage,
  gnugrep,
  lib,
  autoPatchelfHook,
  stdenv,
}:

{
  name,
  src,
  sourceRoot ? null,
  version ? null,
  targets,
  bazel,
  startupArgs ? [ ],
  commandArgs ? [ ],
  env ? { },
  serverJavabase ? null,
  registry ? null,
  bazelRepoCacheFOD ? {
    outputHash = null;
    outputHashAlgo = "sha256";
  },
  bazelVendorDepsFOD ? {
    outputHash = null;
    outputHashAlgo = "sha256";
  },
  installPhase,
  buildInputs ? [ ],
  nativeBuildInputs ? [ ],
  autoPatchelfIgnoreMissingDeps ? null,
}:
let
  # FOD produced by `bazel fetch`
  # Repo cache contains content-addressed external Bazel dependencies without any patching
  # Potentially this can be nixified via --experimental_repository_resolved_file
  # (Note: file itself isn't reproducible because it has lots of extra info and order
  #        isn't stable too. Parsing it into nix fetch* commands isn't trivial but might be possible)
  bazelRepoCache =
    if bazelRepoCacheFOD.outputHash == null then
      null
    else
      (callPackage ./bazelDerivation.nix { } {
        name = "bazelRepoCache";
        inherit (bazelRepoCacheFOD) outputHash outputHashAlgo;
        inherit
          src
          version
          sourceRoot
          env
          buildInputs
          nativeBuildInputs
          ;
        inherit registry;
        inherit
          bazel
          targets
          startupArgs
          serverJavabase
          ;
        command = "fetch";
        outputHashMode = "recursive";
        commandArgs = [ "--repository_cache=repo_cache" ] ++ commandArgs;
        bazelPreBuild = ''
          mkdir repo_cache
        '';
        installPhase = ''
          mkdir -p $out/repo_cache
          cp -r --reflink=auto repo_cache/* $out/repo_cache
        '';
      });
  # Stage1: FOD produced by `bazel vendor`, Stage2: eventual patchelf or other tuning
  # Vendor deps contains unpacked&patches external dependencies, this may need Nix-specific
  # patching to address things like
  # - broken symlinks
  # - symlinks or other references to absolute nix store paths which isn't allowed for FOD
  # - autoPatchelf for externally-fetched binaries
  #
  # Either repo cache or vendor deps should be enough to build a given package
  bazelVendorDeps =
    if bazelVendorDepsFOD.outputHash == null then
      null
    else
      (
        let
          stage1 = callPackage ./bazelDerivation.nix { } {
            name = "bazelVendorDepsStage1";
            inherit (bazelVendorDepsFOD) outputHash outputHashAlgo;
            inherit
              src
              version
              sourceRoot
              env
              buildInputs
              nativeBuildInputs
              ;
            inherit registry;
            inherit
              bazel
              targets
              startupArgs
              serverJavabase
              ;
            dontFixup = true;
            command = "vendor";
            outputHashMode = "recursive";
            commandArgs = [ "--vendor_dir=vendor_dir" ] ++ commandArgs;
            bazelPreBuild = ''
              mkdir vendor_dir
            '';
            bazelPostBuild = ''
              # remove symlinks that point to locations under bazel_src/
              find vendor_dir -type l -lname "$HOME/*" -exec rm '{}' \;
              # remove symlinks to temp build directory on darwin
              find vendor_dir -type l -lname "/private/var/tmp/*" -exec rm '{}' \;
              # remove broken symlinks
              find vendor_dir -xtype l -exec rm '{}' \;

              # remove .marker files referencing NIX_STORE as those references aren't allowed in FOD
              (${gnugrep}/bin/grep -rI "$NIX_STORE/" vendor_dir --files-with-matches --include="*.marker" --null || true) \
                | xargs -0 --no-run-if-empty rm
            '';
            installPhase = ''
              mkdir -p $out/vendor_dir
              cp -r --reflink=auto vendor_dir/* $out/vendor_dir
            '';

          };
        in
        stdenv.mkDerivation {
          name = "bazelVendorDeps";
          buildInputs = lib.optional (!stdenv.hostPlatform.isDarwin) autoPatchelfHook ++ buildInputs;
          inherit autoPatchelfIgnoreMissingDeps;
          src = stage1;
          installPhase = ''
            cp -r . $out
          '';
        }
      );

  package = callPackage ./bazelDerivation.nix { } {
    inherit
      name
      src
      version
      sourceRoot
      env
      buildInputs
      nativeBuildInputs
      ;
    inherit registry bazelRepoCache bazelVendorDeps;
    inherit
      bazel
      targets
      startupArgs
      serverJavabase
      commandArgs
      ;
    inherit installPhase;
    command = "build";
  };
in
package // { passthru = { inherit bazelRepoCache bazelVendorDeps; }; }
