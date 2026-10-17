{
  lib,
  fetchFromGitHub,
  nodejs_24,
  buildNpmPackage,
}:
let
  nixVersion = "1.4.0";
  ghHash = "sha256-fX4B6osknyyr0a3IadCIdQPR/iL4vbe8iUC/cOtrCVs=";
  npmHash = "sha256-62jtyccDlvqp6OZP0DcmuPBv82xZms1u/m2SEedcHEg=";
in
buildNpmPackage {
  pname = "instagram-cli";
  version = nixVersion;

  src = fetchFromGitHub {
    owner = "supreme-gg-gg";
    repo = "instagram-cli";
    tag = "ts-v${nixVersion}";
    hash = ghHash;
  };

  npmDepsHash = npmHash;

  nativeBuildInputs = [
    nodejs_24
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp -a "./dist/." "$out/bin"
    cp -a "./node_modules" "$out"

    makeWrapper "${nodejs_24}/bin/node" "$out/bin/instagram-cli" \
      --add-flags "$out/bin/cli.js"

    runHook postInstall
  '';

  meta = {
    mainProgram = "instagram-cli";
    description = "Unofficial CLI and terminal client for Instagram";
    homepage = "https://github.com/supreme-gg-gg/instagram-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ udontur ];
    platforms = lib.platforms.all;
  };
}
