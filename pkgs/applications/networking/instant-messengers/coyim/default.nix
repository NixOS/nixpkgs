{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig,
  cairo, gdk_pixbuf, glib, gnome3, wrapGAppsHook, gtk3 }:

buildGoPackage rec {
  name = "coyim-${version}";
  version = "0.3.11";

  goPackagePath = "github.com/coyim/coyim";

  src = fetchFromGitHub {
    owner = "coyim";
    repo = "coyim";
    rev = "v${version}";
    sha256 = "1g8nf56j17rdhhj7pv3ha1rb2mfc0mdvyzl35pgcki08w7iw08j3";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook glib cairo gdk_pixbuf gtk3 gnome3.adwaita-icon-theme ];

  meta = with stdenv.lib; {
    description = "a safe and secure chat client";
    homepage = https://coy.im/;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
