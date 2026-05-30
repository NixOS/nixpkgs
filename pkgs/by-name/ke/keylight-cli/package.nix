{
  lib,
  stdenv,
  fetchFromGitHub,
  babashka,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keylight-cli";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "versality";
    repo = "keylight-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-boL6Sg+C9OxMEcr5tAFCn8NxCDrJ6I2nMn9/2yMOYRI=";
  };

  buildInputs = [ babashka ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 keylight.bb $out/bin/keylight

    runHook postInstall
  '';

  meta = {
    description = "CLI tool to control Elgato Key Light devices";
    homepage = "https://github.com/versality/keylight-cli";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ versality ];
    mainProgram = "keylight";
    platforms = lib.platforms.all;
  };
})
