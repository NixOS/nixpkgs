{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, dbus, libpulseaudio }:

rustPlatform.buildRustPackage rec {
  pname = "i3status-rust";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = pname;
    rev = "v${version}";
    sha256 = "11qhzjml04njhfa033v98m4yd522zj91s6ffvrm0m6sk7m0wyjsc";
  };

  cargoSha256 = "0jmmxld4rsjj6p5nazi3d8j1hh7r34q6kyfqq4wv0sjc77gcpaxd";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ dbus libpulseaudio ];

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Very resource-friendly and feature-rich replacement for i3status";
    homepage = "https://github.com/greshake/i3status-rust";
    license = licenses.gpl3;
    maintainers = with maintainers; [ backuitist globin ma27 ];
    platforms = platforms.linux;
  };
}
