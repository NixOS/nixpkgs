{ lib, fetchFromGitHub, rustPlatform, alsa-lib, atk, cairo, dbus, gdk-pixbuf, glib, gtk3, pango, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "psst";
  version = "unstable-2022-01-25";

  src = fetchFromGitHub {
    owner = "jpochyla";
    repo = pname;
    rev = "1627cd4a301dd51e9ee3034294cd7b0d94d02ddc";
    sha256 = "sha256-kepvYhmieXx6Hj79aqaA7tYUnueaBsNx0U4lV7K6LuU=";
  };

  cargoSha256 = "sha256-DcdlQudGyWUUAacV7pAOLDvhd1fgAkEesdxDkHSYm4M=";
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
