{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
}:

stdenvNoCC.mkDerivation {
  pname = "candy-icons";
  version = "0.6.9";

  nativeBuildInputs = [ gtk3 ];

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "candy-icons";
    rev = "1b11884f21712a73489023a8b67015afd9c6695c";
    hash = "sha256-eZrKMWFM05OIi1zW4lP4dibzDOYdoBj/c9a+89/c2W8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/candy-icons
    ls
    mv * $out/share/icons/candy-icons

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache --force $theme
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "An icon theme colored with sweet gradients";
    homepage = "https://github.com/EliverLara/candy-icons";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ eneoli ];
    platforms = platforms.all;
  };
}
