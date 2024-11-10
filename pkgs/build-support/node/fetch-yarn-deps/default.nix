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
  prefetch-yarn-deps,
  fixup-yarn-lock,
  yarn,
  yarn-berry_3,
  yarn-berry_4,
  makeSetupHook,
  cacert,
  callPackage,
  nix,
}:

let
  yarnpkg-lockfile-tar = fetchurl {
    url = "https://registry.yarnpkg.com/@yarnpkg/lockfile/-/lockfile-1.1.0.tgz";
    hash = "sha512-GpSwvyXOcOOlV70vbnzjj4fW5xW/FdUF6nQEt1ENy7m4ZCczi1+/buVUPAqmGfqznsORNFzUMjctTIp8a9tuCQ==";
  };

  tests = callPackage ./tests { };
in
{
  prefetch-yarn-deps = stdenv.mkDerivation {
    name = "prefetch-yarn-deps";

    dontUnpack = true;
    dontBuild = true;

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ nodejs-slim ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/libexec

      tar --strip-components=1 -xf ${yarnpkg-lockfile-tar} package/index.js
      mv index.js $out/libexec/yarnpkg-lockfile.js
      cp ${./common.js} $out/libexec/common.js
      cp ${./index.js} $out/libexec/index.js

      patchShebangs $out/libexec
      makeWrapper $out/libexec/index.js $out/bin/prefetch-yarn-deps \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            nix-prefetch-git
            nix
          ]
        }

      runHook postInstall
    '';

    passthru = {
      inherit tests;
    };
  };

  fixup-yarn-lock = stdenv.mkDerivation {
    name = "fixup-yarn-lock";

    dontUnpack = true;
    dontBuild = true;

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ nodejs-slim ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/libexec

      tar --strip-components=1 -xf ${yarnpkg-lockfile-tar} package/index.js
      mv index.js $out/libexec/yarnpkg-lockfile.js
      cp ${./common.js} $out/libexec/common.js
      cp ${./fixup.js} $out/libexec/fixup.js

      patchShebangs $out/libexec
      makeWrapper $out/libexec/fixup.js $out/bin/fixup-yarn-lock

      runHook postInstall
    '';

    passthru = {
      inherit tests;
    };
  };

  # TODO: Move from `yarnLock` environment variable to the actual `src` argument for
  # `yarn` and `yarn-berry`. This should work for both versions in place, because both
  # versions will look for a yarn.lock file in the current working directory (`src`)
  fetchYarnDeps =
    let
      f =
        {
          name ? "offline",
          src ? null,
          hash ? "",
          sha256 ? "",
          yarnVersion ? 1,
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
              (
                {
                  "1" = prefetch-yarn-deps;
                  "3" = yarn-berry_3;
                  "4" = yarn-berry_4;
                }
                .${builtins.toString yarnVersion}
              )
              cacert
            ];
            GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
            NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";

            configurePhase = lib.optionalString (yarnVersion > 1) ''
              runHook preConfigure

              export HOME="$NIX_BUILD_TOP"
              export YARN_ENABLE_TELEMETRY=0
              yarnLock=''${yarnLock:=$PWD/yarn.lock}
              DIR=$(dirname $yarnLock)
              if [ $DIR = "${builtins.storeDir}" ]; then
                echo "Only a yarn.lock file has been passed (e.g. yarnLock = ./yarn.lock;)"
                echo "Please change this so a directory can be deduced (e.g. yarnLock = finalAttrs.src + "/yarn.lock";)"
                exit 1
              fi
              if [ ! -f $DIR/package.json ]; then
                echo "No package.json has been found in the same directory as the yarn.lock file"
                exit 1
              fi
              if ! grep -q "__metadata:" $DIR/yarn.lock; then
                echo "This yarn.lock file appears to be a version 1 yarn.lock file"
                echo "Please use fetchYarnDeps with yarnVersion = 1"
                exit 1
              fi
              cp $DIR/yarn.lock $DIR/package.json $HOME/
              chmod +w $HOME/yarn.lock $HOME/package.json
              yarn config set enableGlobalCache false
              yarn config set cacheFolder $out
              yarn config set supportedArchitectures --json "$(cat ${./yarn-berry-supported-archs.json})"

              runHook postConfigure
            '';

            buildPhase =
              ''
                runHook preBuild

                mkdir -p $out
              ''
              + lib.optionalString (yarnVersion > 1) ''
                yarn install --immutable --mode skip-build
              ''
              + lib.optionalString (yarnVersion == 1) ''
                yarnLock=''${yarnLock:=$PWD/yarn.lock}
                if grep -q "__metadata:" $yarnLock; then
                  echo "This yarn.lock file does not appear to be a version 1 yarn.lock file"
                  echo "Please use fetchYarnDeps with eiher yarnVersion = 3 or yarnVersion = 4"
                  exit 1
                fi
                (cd $out; prefetch-yarn-deps --verbose --builder $yarnLock)
              ''
              + ''
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

  yarnConfigHook = makeSetupHook {
    name = "yarn-config-hook";
    propagatedBuildInputs = [
      yarn
      fixup-yarn-lock
    ];
    meta = {
      description = "Install nodejs dependencies from an offline yarn cache produced by fetchYarnDeps";
    };
  } ./yarn-config-hook.sh;

  yarnBerry3ConfigHook = makeSetupHook {
    name = "yarn-config-hook";
    propagatedBuildInputs = [ yarn-berry_3 ];
    substitutions = {
      yarn = lib.getExe yarn-berry_3;
    };
    meta = {
      description = "Install nodejs dependencies from an offline yarn berry cache (version 3)";
    };
  } ./yarn-berry-config-hook.sh;

  yarnBerry4ConfigHook = makeSetupHook {
    name = "yarn-config-hook";
    propagatedBuildInputs = [ yarn-berry_4 ];
    substitutions = {
      yarn = lib.getExe yarn-berry_4;
    };
    meta = {
      description = "Install nodejs dependencies from an offline yarn berry cache (version 4)";
    };
  } ./yarn-berry-config-hook.sh;

  yarnBuildHook = makeSetupHook {
    name = "yarn-build-hook";
    meta = {
      description = "Run yarn build in buildPhase";
    };
  } ./yarn-build-hook.sh;

  yarnInstallHook = makeSetupHook {
    name = "yarn-install-hook";
    propagatedBuildInputs = [
      yarn
      nodejsInstallManuals
      nodejsInstallExecutables
    ];
    substitutions = {
      jq = lib.getExe jq;
    };
  } ./yarn-install-hook.sh;
}
