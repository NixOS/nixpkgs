{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, dbus, libpulseaudio }:

rustPlatform.buildRustPackage rec {
  name = "i3status-rust-${version}";
  version = "0.9.0.2019-02-15";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = "i3status-rust";
    rev = "2dc958995834b529a245c22c510b57d5c928c747";
    sha256 = "091a2pqgkiwnya2xv5rw5sj730hf6lvkp2kk5midsa3wz2dfbc2j";
  };

  cargoSha256 = "06izzv86nkn1izapldysyryz9zvjxvq23c742z284bnxjfq5my6i";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ dbus libpulseaudio ];

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Very resource-friendly and feature-rich replacement for i3status";
    homepage = https://github.com/greshake/i3status-rust;
    license = licenses.gpl3;
    maintainers = [ maintainers.backuitist ];
    platforms = platforms.linux;
  };
}
