{
  stdenv,
  lib,
  makeWrapper,
  installShellFiles,
  nodejsInstallManuals,
  nodejsInstallExecutables,
  coreutils,
  nix-prefetch-git,
  fetchurl,
  jq,
  nodejs,
  nodejs-slim,
  diffutils,
  bun,
  makeSetupHook,
  cacert,
  callPackage,
}:

let
  tests = callPackage ./tests { };
in
{
  prefetch-bun-deps = stdenv.mkDerivation {
    name = "prefetch-bun-deps";

    dontUnpack = true;
    dontBuild = true;

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ nodejs-slim ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/libexec

      cp ${./common.js} $out/libexec/common.js
      cp ${./index.js} $out/libexec/index.js

      patchShebangs $out/libexec
      makeWrapper $out/libexec/index.js $out/bin/prefetch-bun-deps \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            nix-prefetch-git
          ]
        }

      runHook postInstall
    '';

    passthru = {
      inherit tests;
    };
  };

  fixup-bun-lock = stdenv.mkDerivation {
    name = "fixup-bun-lock";

    dontUnpack = true;
    dontBuild = true;

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ nodejs-slim ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/libexec

      cp ${./common.js} $out/libexec/common.js
      cp ${./fixup.js} $out/libexec/fixup.js

      patchShebangs $out/libexec
      makeWrapper $out/libexec/fixup.js $out/bin/fixup-bun-lock

      runHook postInstall
    '';

    passthru = {
      inherit tests;
    };
  };

  fetchBunDeps =
    let
      f =
        {
          name ? "offline",
          src ? null,
          hash ? "",
          sha256 ? "",
          ...
        }@args:
        let
          hash_ =
            if hash != "" then
              {
                outputHashAlgo = null;
                outputHash = hash;
              }
            else if sha256 != "" then
              {
                outputHashAlgo = "sha256";
                outputHash = sha256;
              }
            else
              {
                outputHashAlgo = "sha256";
                outputHash = lib.fakeSha256;
              };
        in
        stdenv.mkDerivation (
          {
            inherit name;

            dontUnpack = src == null;
            dontInstall = true;

            nativeBuildInputs = [
              (callPackage ./. { }).prefetch-bun-deps
              cacert
            ];
            GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
            NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";

            buildPhase = ''
              runHook preBuild

              bunLock=''${bunLock:=$PWD/bun.lock}
              mkdir -p $out
              (cd $out; prefetch-bun-deps --verbose --builder $bunLock)

              runHook postBuild
            '';

            outputHashMode = "recursive";
          }
          // hash_
          // (removeAttrs args (
            [
              "name"
              "hash"
              "sha256"
            ]
            ++ (lib.optional (src == null) "src")
          ))
        );
    in
    lib.setFunctionArgs f (lib.functionArgs f) // { inherit tests; };

  bunConfigHook = makeSetupHook {
    name = "bun-config-hook";
    propagatedBuildInputs = [
      bun
      (callPackage ./. { }).fixup-bun-lock
    ];
    substitutions = {
      # Specify `diff` by abspath to ensure that the user's build
      # inputs do not cause us to find the wrong binaries.
      diff = "${diffutils}/bin/diff";
    };
    meta = {
      description = "Install nodejs dependencies from an offline bun cache produced by fetchBunDeps";
    };
  } ./bun-config-hook.sh;

  bunBuildHook = makeSetupHook {
    name = "bun-build-hook";
    meta = {
      description = "Run bun build in buildPhase";
    };
  } ./bun-build-hook.sh;

  bunInstallHook = makeSetupHook {
    name = "bun-install-hook";
    propagatedBuildInputs = [
      bun
      nodejsInstallManuals
      nodejsInstallExecutables
    ];
    substitutions = {
      jq = lib.getExe jq;
    };
  } ./bun-install-hook.sh;
}
