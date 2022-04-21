{ lib, fetchFromGitHub, rustPlatform, alsa-lib, atk, cairo, dbus, gdk-pixbuf, glib, gtk3, pango, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "psst";
  version = "unstable-2022-03-19";

  src = fetchFromGitHub {
    owner = "jpochyla";
    repo = pname;
    rev = "2d2cf6511da401b7e8e6e3c16b9386b9fb8f6c92";
    sha256 = "sha256-E0cgs1e67bky8VMxUcKDCoMba48fVkCqDDo4MhEwpBA=";
  };

  cargoSha256 = "sha256-nMeBRS/0JfHoo96AVcusO4CJlDSqGkWlYif8+gXG7AE=";
  # specify the subdirectory of the binary crate to build from the workspace
  buildAndTestSubdir = "psst-gui";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    atk
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk3
    pango
  ];

  meta = with lib; {
    description = "Fast and multi-platform Spotify client with native GUI";
    homepage = "https://github.com/jpochyla/psst";
    license = licenses.mit;
    maintainers = [ maintainers.vbrandl ];
  };
}
