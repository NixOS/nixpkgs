{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "betterdiscordctl";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "bb010g";
    repo = "betterdiscordctl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SA2z1dqtc/whGe75Zbn9St7ekYnEr2xDuWowRMICYu0=";
  };

  postPatch = ''
    substituteInPlace betterdiscordctl \
      --replace-fail "DISABLE_SELF_UPGRADE=" "DISABLE_SELF_UPGRADE=yes"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 755 -t "$out/bin" -- betterdiscordctl
    install -Dm 644 -t "$out/share/doc/betterdiscordctl" -- README.md

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    "$out/bin/betterdiscordctl" --version

    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://github.com/bb010g/betterdiscordctl";
    description = "Utility for managing BetterDiscord on Linux";
    license = lib.licenses.mit;
    mainProgram = "betterdiscordctl";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
