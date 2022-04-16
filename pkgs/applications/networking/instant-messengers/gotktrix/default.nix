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
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "diamondburned";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/UDXqN7FnFvbiXp3pID1WbNfCuKDsMrFQvL1101xxOo=";
  };

  vendorSha256 = "sha256-xA2DW4v6aT4fEW2WSa96oRr5Yrb2HoR054V1+BiWSvk=";

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
