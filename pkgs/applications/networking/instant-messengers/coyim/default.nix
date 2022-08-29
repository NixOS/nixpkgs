{ lib, buildGoPackage, fetchFromGitHub, pkg-config,
  cairo, gdk-pixbuf, glib, gnome, wrapGAppsHook, gtk3 }:

buildGoPackage rec {
  pname = "coyim";
  version = "0.4";

  goPackagePath = "github.com/coyim/coyim";

  src = fetchFromGitHub {
    owner = "coyim";
    repo = "coyim";
    rev = "v${version}";
    sha256 = "sha256-dpTU5Tx1pfUGZMt9QNEYDytgArhhvEvh1Yvj6IAjgeI=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  buildInputs = [ glib cairo gdk-pixbuf gtk3 gnome.adwaita-icon-theme ];

  meta = with lib; {
    description = "a safe and secure chat client";
    homepage = "https://coy.im/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
