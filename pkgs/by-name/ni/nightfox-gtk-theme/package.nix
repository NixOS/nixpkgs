{ lib
, stdenvNoCC
, fetchFromGitHub
, gnome-themes-extra
, gtk-engine-murrine
}:

stdenvNoCC.mkDerivation {
  pname = "nightfox-gtk-theme";
  version = "unstable-2023-05-28";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Nightfox-GTK-Theme";
    rev = "a8b01a28f2d1d9dd57d98d3708602b0d72340338";
    hash = "sha256-GrlKYCqO9vgRbPdPhugPBg2rYtDxzbQwRPtTBIyIyx4=";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  buildInputs = [
    gnome-themes-extra
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a themes/* $out/share/themes
    runHook postInstall
  '';

  meta = with lib; {
    description = "A GTK theme based on the Nightfox colour palette";
    homepage = "https://github.com/Fausto-Korpsvart/Nightfox-GTK-Theme";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
  };
}
