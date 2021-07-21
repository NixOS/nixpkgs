{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, cairo
, gobject-introspection
, gtk3
, gtk-layer-shell
}:

buildGoModule rec {
  pname = "nwg-drawer";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YjMuXSBAgRh6vZUxKHLTqT2lEU/f+AuI/dX4PHfftZg=";
  };

  vendorSha256 = "sha256-HyrjquJ91ddkyS8JijHd9HjtfwSQykXCufa2wzl8RNk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ cairo gobject-introspection gtk3 gtk-layer-shell ];

  meta = with lib; {
    description = "Application drawer for sway Wayland compositor";
    homepage = "https://github.com/nwg-piotr/nwg-drawer";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ plabadens ];
  };
}
