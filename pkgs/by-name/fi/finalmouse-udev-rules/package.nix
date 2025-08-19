{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "finalmouse-udev-rules";
  version = "0-unstable-2025-05-05";

  src = fetchFromGitHub {
    owner = "teamfinalmouse";
    repo = "xpanel-linux-permissions";
    rev = "60c4ed794bd946e467559cc572cf25bb99bf04b6";
    hash = "sha256-E2xhm+8fFlxgIKjZlAvosLk/KgbmLk01BjK++y8laBc=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dpm644 $src/99-finalmouse.rules $out/lib/udev/rules.d/70-finalmouse.rules

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
