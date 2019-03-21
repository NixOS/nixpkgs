{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig,
  cairo, gdk_pixbuf, glib, gnome3, wrapGAppsHook, gtk3 }:

buildGoPackage rec {
  name = "coyim-${version}";
  version = "0.3.7_1";

  goPackagePath = "github.com/twstrike/coyim";

  src = fetchFromGitHub {
    owner = "twstrike";
    repo = "coyim";
    rev = "df2c52fe865d38fa27e8a7af1d87612e8c048805";
    sha256 = "1sna1n9dz1crws6cb1yjhy2kznbngjlbiw2diycshvbfigf7y7xl";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook glib cairo gdk_pixbuf gtk3 gnome3.adwaita-icon-theme ];

  meta = with stdenv.lib; {
    description = "a safe and secure chat client";
    homepage = https://coy.im/;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
