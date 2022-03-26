{ lib, buildGoPackage, fetchFromGitHub, pkg-config,
  cairo, gdk-pixbuf, glib, gnome, wrapGAppsHook, gtk3 }:

buildGoPackage rec {
  pname = "coyim";
  version = "0.3.11";

  goPackagePath = "github.com/coyim/coyim";

  src = fetchFromGitHub {
    owner = "coyim";
    repo = "coyim";
    rev = "v${version}";
    sha256 = "1g8nf56j17rdhhj7pv3ha1rb2mfc0mdvyzl35pgcki08w7iw08j3";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  buildInputs = [ glib cairo gdk-pixbuf gtk3 gnome.adwaita-icon-theme ];

  meta = with lib; {
    description = "a safe and secure chat client";
    homepage = "https://coy.im/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    broken = true; #fails to build with go >= 1.16
  };
}
