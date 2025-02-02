{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
}:

stdenvNoCC.mkDerivation {
  pname = "candy-icons";
  version = "unstable-2023-12-31";

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "candy-icons";
    rev = "e4464d7b4d8e1821025447b2064b6a8f5c4c8c89";
    hash = "sha256-XdYjxWf8R4b1GK2iFQnoEOWykc19ZT37ki83WeESQBM=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/candy-icons
    cp -r . $out/share/icons/candy-icons
    gtk-update-icon-cache $out/share/icons/candy-icons

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/EliverLara/candy-icons";
    description = "An icon theme colored with sweet gradients";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ clr-cera ];
  };
}
