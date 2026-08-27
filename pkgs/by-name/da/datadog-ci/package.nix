{
  stdenv,
  fetchFromGitHub,
  lib,
  makeWrapper,
  nix-update-script,
  nodejs,
  writeShellApplication,
  yarn-berry_4,
}:
let
  yarn-berry = yarn-berry_4;

  yarnHash = "sha256-eqVITK15LjpNPiJn7Ag3OW3OM0hLgskyxjF4LclXZ6Q=";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "datadog-ci";
  version = "5.19.0";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "datadog-ci";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nQKaKSp0ylNPAx7pgb5Vgl9HIj0jTrdRA260iE3tlBc=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  buildPhase = ''
    runHook preBuild

    yarn build

    runHook postBuild
  '';

  nativeBuildInputs = [
    makeWrapper
    nodejs
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = yarnHash;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    subfolders=("package.json" "dist" "node_modules")
    for p in packages/*; do
      for s in "''${subfolders[@]}"; do
        echo "Copying dist from $p/$s"
        if [ -e "$p/$s" ]; then
          mkdir -p "$out/$p"
          cp -r "$p/$s" "$out/$p"
        fi
      done
    done

    cp -r "node_modules" $out/node_modules

    makeWrapper "${lib.getExe nodejs}" "$out/bin/datadog-ci" \
      --add-flags "$out/packages/datadog-ci/dist/cli.js"

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "Use Datadog from your CI";
    longDescription = ''
      Execute commands from your Continuous Integration (CI) and Continuous Delivery (CD) pipelines to integrate with existing Datadog products.
    '';
    homepage = "https://github.com/DataDog/datadog-ci";
    license = lib.licensesSpdx."Apache-2.0";
    maintainers = with lib.maintainers; [ ibizaman ];
    platforms = lib.platforms.all;
  };
})
