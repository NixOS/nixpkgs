{
  bash,
  coreutils,
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
  postUnpack ? null,
  bazelPreBuild ? "", # TODO: find a better interface, currently whether it is before or mkdir isn't clear
  patches ? [ ],
  installPhase,
  buildInputs ? [ ],
  nativeBuildInputs ? [ ],
  autoPatchelfIgnoreMissingDeps ? null,
  autoPatchelfVendorDirs ? [ ],
  passthru ? { },
}:
let
  # FOD produced by `bazel fetch`
  # Repo cache contains content-addressed external Bazel dependencies without any patching
  # Potentially this can be nixified via --experimental_repository_resolved_file
  # (Note: file itself isn't reproducible because it has lots of extra info and order
  #        isn't stable too. Parsing it into nix fetch* commands isn't trivial but might be possible)
  bazelRepoCache =
    if bazelRepoCacheFOD.outputHash == null then
      # TODO: make repo cache required now that vendor FOD is removed?
      null
    else
      (callPackage ./bazelDerivation.nix { } {
        # TODO: get rid of following steps to avoid possible bazel content-addressing issues?
        # - shrinking RPATHs of ELF executables and libraries
        # - patching script interpreter paths
        name = "bazelRepoCache";
        inherit (bazelRepoCacheFOD) outputHash outputHashAlgo;
        inherit
          src
          postUnpack
          patches
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
        ''
        + bazelPreBuild;
        installPhase = ''
          mkdir -p $out/repo_cache
          cp -r --reflink=auto repo_cache/* $out/repo_cache
        '';
      });
  # Vendor deps contains unpacked&patches external dependencies, this may need Nix-specific
  # patching to address things like
  # - broken symlinks
  # - symlinks or other references to absolute nix store paths which isn't allowed for FOD
  # - autoPatchelf for externally-fetched binaries
  #
  # Either repo cache or vendor deps should be enough to build a given package
  # TODO: make vendoring stage opt-in if no patching is needed
  # TODO: also consider simple text patching ability via registry rewrites
  #
  # TODO: maybe vendorDeps should be fused with the main build? It's not a FOD anymore so why not
  #       consider patching a patch phase during package build step? Would save disk space - repoCache
  #       can be often compressed, vendorDeps are uncompressed and cover same content, modulo applied patches.
  #       As opt-in it might be useful to grab patched vendor deps to debug outside nix build?
  package = callPackage ./bazelDerivation.nix { } {
    inherit
      name
      src
      postUnpack
      patches
      version
      sourceRoot
      env
      nativeBuildInputs
      ;
    buildInputs = lib.optional (!stdenv.hostPlatform.isDarwin) autoPatchelfHook ++ buildInputs;
    inherit autoPatchelfIgnoreMissingDeps;
    # autoPatchelf will cross-link different jdks if run on top-level, we'll run manually
    dontAutoPatchelf = true;
    bazelPreBuild = ''
      mkdir vendor_dir
      ${bazelPreBuild}
      ${bazel}/bin/bazel ${
        lib.escapeShellArgs (
          lib.optional (serverJavabase != null) "--server_javabase=${serverJavabase}"
          ++ [ "--batch" ]
          ++ startupArgs
        )
      } vendor ${
        lib.escapeShellArgs (
          [ "--vendor_dir=vendor_dir" ]
          ++ lib.optional (registry != null) "--registry=file://${registry}"
          ++ lib.optional (bazelRepoCache != null) "--repository_cache=repo_cache"
          ++ commandArgs
          ++ targets
        )
      }

                    function sedVerbose() {
                      local path=$1; shift;
                      sed -i".bak-nix" "$path" "$@"
                      diff -U0 "$path.bak-nix" "$path" | sed "s/^/  /" || true
                      rm -f "$path.bak-nix"
                    }
                    # TODO: make opt-in & customizable
                    ${gnugrep}/bin/grep -rlZ --include="*.bzl" --include "BUILD.bazel" --include "BUILD" /bin/bash vendor_dir \
                      | while IFS="" read -r -d "" path; do
                          echo "$path"
                          sedVerbose "$path" \
                            -e 's!/usr/bin/bash!${bash}/bin/bash!g' \
                            -e 's!/bin/bash!${bash}/bin/bash!g'
                      done;
                    # TODO: make opt-in & customizable
                    ${gnugrep}/bin/grep -rlZ --include="*.bzl" --include "BUILD.bazel" --include "BUILD" --include "java_stub_template.txt" /usr/bin/env vendor_dir \
                      | while IFS="" read -r -d "" path; do
                          echo "$path"
                          sedVerbose "$path" \
                            -e 's!/usr/bin/env bash!${bash}/bin/bash!g' \
                            -e 's!/usr/bin/env!${coreutils}/bin/env!g'
                      done;

      # autoPatchelf may fail on some paths without permissions change
      chmod -R u+w vendor_dir
      ${builtins.concatStringsSep "\n" (
        map (d: "autoPatchelf \"vendor_dir/${d}\"") autoPatchelfVendorDirs
      )}
    '';
    inherit registry bazelRepoCache;
    inherit
      bazel
      targets
      startupArgs
      serverJavabase
      ;
    commandArgs = commandArgs ++ [ "--vendor_dir=vendor_dir" ];
    inherit installPhase;
    command = "build";

    passthru = passthru // {
      inherit bazelRepoCache;
    };
  };
in
package
