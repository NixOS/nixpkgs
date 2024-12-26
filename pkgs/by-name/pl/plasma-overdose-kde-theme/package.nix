{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "plasma-overdose-kde-theme";
  version = "unstable-2022-05-30";

  src = fetchFromGitHub {
    owner = "Notify-ctrl";
    repo = "Plasma-Overdose";
    rev = "d8bf078b4819885d590db27cd1d25d8f4f08fe4c";
    sha256 = "187f6rlvb2wf5sj3mgr69mfwh9fpqchw4yg6nzv54l98msmxc4h0";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    mv colorschemes $out/share/color-schemes
    mv plasma $out/share/plasma

    mkdir -p $out/share/aurorae
    mv aurorae $out/share/aurorae/themes

    mkdir -p $out/share/icons/Plasma-Overdose
    mv cursors/index.theme $out/share/icons/Plasma-Overdose/cursor.theme
    mv cursors/cursors $out/share/icons/Plasma-Overdose/cursors

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cute KDE theme inspired by the game Needy Girl Overdose";
    homepage = "https://github.com/Notify-ctrl/Plasma-Overdose";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ takagiy ];
  };
}
