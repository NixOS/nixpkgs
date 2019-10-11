{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, dbus, libpulseaudio }:

rustPlatform.buildRustPackage rec {
  pname = "i3status-rust";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = pname;
    rev = "v${version}";
    sha256 = "15083nagd0kzpkay5jxcq5i16yvybd4sh03g9x4q9xq4cy0qwj11";
  };

  cargoSha256 = "1cbx2jll0bj547dvwzjprzidndbqn1c4c6hmbfgjgdkxmmrpb0r1";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ dbus libpulseaudio ];

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Very resource-friendly and feature-rich replacement for i3status";
    homepage = https://github.com/greshake/i3status-rust;
    license = licenses.gpl3;
    maintainers = with maintainers; [ backuitist globin ];
    platforms = platforms.linux;
  };
}
