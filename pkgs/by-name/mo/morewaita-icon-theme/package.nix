{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  xdg-utils,
}:
stdenvNoCC.mkDerivation rec {
  pname = "morewaita-icon-theme";
  version = "45";

  src = fetchFromGitHub {
    owner = "somepaulo";
    repo = "MoreWaita";
    rev = "v${version}";
    hash = "sha256-UtwigqJjkin53Wg3PU14Rde6V42eKhmP26a3fDpbJ4Y=";
  };

  nativeBuildInputs = [
    gtk3
    xdg-utils
  ];

  installPhase = ''
    runHook preInstall

    install -d $out/share/icons/MoreWaita
    cp -r . $out/share/icons/MoreWaita
    gtk-update-icon-cache -f -t $out/share/icons/MoreWaita && xdg-desktop-menu forceupdate

    runHook postInstall
  '';

  meta = with lib; {
    description = "An Adwaita style extra icons theme for Gnome Shell";
    homepage = "https://github.com/somepaulo/MoreWaita";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ pkosel ];
  };
}
