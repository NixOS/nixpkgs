{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:

buildNpmPackage (finalAttrs: {
  pname = "ha-linky";
  version = "1.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bokub";
    repo = "ha-linky";
    tag = finalAttrs.version;
    hash = "sha256-4hQ5bQ2CxlSDLw4yxakOpnij2gJ0FSyH8OWjX4iCkOE=";
  };

  npmDepsHash = "sha256-j8q0ouD9BSnQ3Yb2tsn+tON+YXh30fynnlDtNbtiVyQ=";

  patches = [
    ./config-path.patch
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/ha-linky
    mkdir $out/bin
    mv node_modules package-lock.json repository.yaml tsconfig.json src \
      config.yaml dist icon.png logo.png package.json $out/lib/node_modules/ha-linky/
    makeWrapper ${lib.getExe nodejs} $out/bin/ha-linky \
      --add-flags "$out/lib/node_modules/ha-linky/dist/index.js" \
      --set "NODE_PATH" "$out/lib/node_modules/ha-linky/node_modules"

    runHook postInstall
  '';

  meta = {
    description = "Home Assistant app to sync Energy dashboards with your Linky smart meter";
    homepage = "https://github.com/bokub/ha-linky";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ratcornu ];
    mainProgram = "ha-linky";
  };
})
