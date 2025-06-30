{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "catppuccin-qt5ct";
  version = "2023-03-21";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "qt5ct";
    rev = "89ee948e72386b816c7dad72099855fb0d46d41e";
    hash = "sha256-t/uyK0X7qt6qxrScmkTU2TvcVJH97hSQuF0yyvSO/qQ=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/qt5ct
    cp -r themes $out/share/qt5ct/colors
    runHook postInstall
  '';

  meta = with lib; {
    description = "Soothing pastel theme for qt5ct";
    homepage = "https://github.com/catppuccin/qt5ct";
    license = licenses.mit;
    maintainers = with maintainers; [ pluiedev ];
    platforms = platforms.all;
  };
}
