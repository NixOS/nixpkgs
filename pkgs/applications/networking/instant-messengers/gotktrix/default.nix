{ lib
, buildGoModule
, fetchFromGitHub
, gtk4
, glib
, gobject-introspection
, pkg-config
, go
}:

buildGoModule rec {
  pname = "gotktrix";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "diamondburned";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9feKg/rnkWdJRolHBQ5WT6Rl3xTFe82M8HyxJK3VuN4=";
  };

  vendorSha256 = "sha256-eO/2MvWOVCeeCsiU2mSwgSEVlSbCXOp8qHyoG0lmk+Q=";

  buildInputs = [
    gtk4
    glib
    gobject-introspection
  ];

  nativeBuildInputs = [ pkg-config ];

  # Checking requires a working display
  doCheck = false;

  meta = with lib; {
    description = "Matrix client written in Go using GTK4";
    homepage = "https://github.com/diamondburned/gotktrix";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}
