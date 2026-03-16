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
    rev = "13923c07d4739b3c698c3155e37e3770ba61705c";
    hash = "sha256-nBAXMsuJKasEccljZ97IL0eXtDK44pKba8IGGZlh7JU=";
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
