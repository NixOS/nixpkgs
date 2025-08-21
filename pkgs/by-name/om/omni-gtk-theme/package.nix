{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk-engine-murrine,
}:

stdenv.mkDerivation {
  pname = "omni-gtk-theme";
  version = "0-unstable-2021-03-30";

  src = fetchFromGitHub {
    owner = "getomni";
    repo = "gtk";
    rev = "e81b3fbebebf53369cffe1fb662abc400edb04f7";
    sha256 = "sha256-NSZjkG+rY6h8d7FYq5kipPAjMDAgyaYAgOOOJlfqBCI=";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/Omni
    cp -a {assets,gnome-shell,gtk-2.0,gtk-3.0,gtk-3.20,index.theme,metacity-1,unity,xfwm4} $out/share/themes/Omni

    runHook postInstall
  '';

  meta = with lib; {
    description = "Dark theme created by Rocketseat";
    homepage = "https://github.com/getomni/gtk";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ zoedsoupe ];
  };
}
