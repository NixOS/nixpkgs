{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:

buildNpmPackage (finalAttrs: {
  pname = "ha-linky";
  version = "1.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bokub";
    repo = "ha-linky";
    tag = finalAttrs.version;
    hash = "sha256-x8W/kR/L3uJ317MAayv3mUlPW3yw+Tnj4iD2c6CEnOQ=";
  };

  npmDepsHash = "sha256-y/64htlLa5RGemCIqXp9nxDgAK8zyVOq8kdW4azhY64=";

  patches = [
    ./config-path.patch
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/ha-linky
    mkdir $out/bin
    mv * $out/lib/node_modules/ha-linky/
    makeWrapper ${lib.getExe nodejs} $out/bin/ha-linky \
      --add-flags "$out/lib/node_modules/ha-linky/dist/index.js" \
      --set "NODE_PATH" "$out/lib/node_modules/ha-linky/node_modules"

    runHook postInstall
  '';

  meta = {
    description = "A Home Assistant app to sync Energy dashboards with your Linky smart meter";
    homepage = "https://github.com/bokub/ha-linky";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ratcornu ];
    mainProgram = "ha-linky";
  };
})
