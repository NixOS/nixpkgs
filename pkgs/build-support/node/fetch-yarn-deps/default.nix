{
  stdenvNoCC,
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
  diffutils,
  yarn,
  makeSetupHook,
  cacert,
  callPackage,
}:

let
  yarnpkg-lockfile-tar = fetchurl {
    url = "https://registry.yarnpkg.com/@yarnpkg/lockfile/-/lockfile-1.1.0.tgz";
    hash = "sha512-GpSwvyXOcOOlV70vbnzjj4fW5xW/FdUF6nQEt1ENy7m4ZCczi1+/buVUPAqmGfqznsORNFzUMjctTIp8a9tuCQ==";
  };

  tests = callPackage ./tests { };
in
{
  fixup-yarn-lock = stdenvNoCC.mkDerivation {
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
      cp ${./fixup.js} $out/libexec/fixup.js

      patchShebangs $out/libexec
      makeWrapper $out/libexec/fixup.js $out/bin/fixup-yarn-lock

      runHook postInstall
    '';

    passthru = {
      inherit tests;
    };
  };

  yarnConfigHook = makeSetupHook {
    name = "yarn-config-hook";
    propagatedBuildInputs = [
      yarn
      fixup-yarn-lock
    ];
    substitutions = {
      # Specify `diff` by abspath to ensure that the user's build
      # inputs do not cause us to find the wrong binaries.
      diff = "${diffutils}/bin/diff";
    };
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
      yarn
      nodejsInstallManuals
      nodejsInstallExecutables
    ];
    substitutions = {
      jq = lib.getExe jq;
    };
    meta = {
      description = "Prune yarn dependencies and install files for packages using Yarn 1";
    };
  } ./yarn-install-hook.sh;
}
