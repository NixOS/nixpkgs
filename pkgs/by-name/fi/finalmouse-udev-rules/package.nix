{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "finalmouse-udev-rules";
  version = "0-unstable-2026-01-27";

  src = fetchFromGitHub {
    owner = "teamfinalmouse";
    repo = "xpanel-linux-permissions";
    rev = "49ba1bf19e7d1f05306baaf72e4514c1f12f139a";
    hash = "sha256-+tStBzGrPop0zKNf0qIp2PCrVRy2CcFpIrvgft9YkbE=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dpm644 $src/70-finalmouse.rules $out/lib/udev/rules.d/70-finalmouse.rules

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/teamfinalmouse/xpanel-linux-permissions";
    description = "udev rules that give NixOS permission to communicate with Finalmouse mice";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      emilia
    ];
  };
}
