{
  stdenv,
  lib,
  makeWrapper,
  coreutils,
  nix-prefetch-git,
  fetchurl,
  nodejs-slim,
  prefetch-yarn-deps,
  fixup-yarn-lock,
  yarn,
  makeSetupHook,
  cacert,
  callPackage,
  nix,
  installShellFiles,
  jq,
  nodejs,
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

  fetchYarnDeps =
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
              prefetch-yarn-deps
              cacert
            ];
            GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
            NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";

            buildPhase = ''
              runHook preBuild

              yarnLock=''${yarnLock:=$PWD/yarn.lock}
              mkdir -p $out
              (cd $out; prefetch-yarn-deps --verbose --builder $yarnLock)

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

  yarnBuildHook = makeSetupHook {
    name = "yarn-build-hook";
    meta = {
      description = "Run yarn build in buildPhase";
    };
  } ./yarn-build-hook.sh;

  yarnInstallHook = makeSetupHook {
    name = "yarn-install-hook";
    propagatedBuildInputs = [
      installShellFiles
      makeWrapper
    ];
    substitutions = {
      hostNode = "${nodejs}/bin/node";
      jq = "${jq}/bin/jq";
      prunePart = ''
        if [ -z "''${yarnKeepDevDeps-}" ]; then
            # Yarn has a 'prune' command, but it's only a stub that instructs
            # you to use `yarn install`. The goal of this prunePart is to
            # remove the development dependencies from the resulted
            # node_modules directory. Running yarn install here (again - after
            # we ran it inyarnConfigHook), with the --production=true flag,
            # should do the same thing.
            if ! yarn install \
                --frozen-lockfile \
                --force \
                --production=true \
                --ignore-engines \
                --ignore-platform \
                --ignore-scripts \
                --no-progress \
                --non-interactive \
                --offline
            then
              echo
              echo
              echo "ERROR: yarn install --production=true step failed"
              echo
              echo 'If yarn tried to download additional dependencies above, try setting `yarnKeepDevDeps = true`.'
              echo

              exit 1
            fi
        fi
      '';
    };
  } ../build-npm-package/hooks/npm-install-hook.sh;
}
