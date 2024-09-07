{ lib, stdenv, intltool, pkg-config, gtk3, fetchFromGitHub
, autoreconfHook, wrapGAppsHook3 }:

stdenv.mkDerivation rec {
  version = "unstable-2022-02-14";
  pname = "l3afpad";

  src = fetchFromGitHub {
    owner = "stevenhoneyman";
    repo = pname;
    rev = "16f22222116b78b7f6a6fd83289937cdaabed624";
    sha256 = "sha256-ly2w9jmRlprm/PnyC0LYjrxBVK+J0DLiSpzuTUMZpWA=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook wrapGAppsHook3 intltool ];
  buildInputs = [ gtk3 ];

  meta = with lib; {
    description = "Simple text editor forked from Leafpad using GTK+ 3.x";
    homepage = "https://github.com/stevenhoneyman/l3afpad";
    platforms = platforms.linux;
    maintainers = [ ];
    license = licenses.gpl2;
    mainProgram = "l3afpad";
  };
}
