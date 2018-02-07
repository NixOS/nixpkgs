{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, dbus, gperftools }:

rustPlatform.buildRustPackage rec {
  name = "i3status-rust-${version}";
  version = "0.9.0.2018-01-15";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = "i3status-rust";
    rev = "aa7bc98d945ba63358cd48c66e0261c201b999e4";
    sha256 = "1q2p53nl499yxsw0i81ryyc2ln80p8i3iii5hx7aiwfi4ybm55b1";
  };

  cargoSha256 = "1197hp6d4z14j0r22bvw9ly294li0ivg6yfql4lgi27hbvzag71h";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ dbus gperftools ];

  meta = with stdenv.lib; {
    description = "Very resource-friendly and feature-rich replacement for i3status";
    homepage = https://github.com/greshake/i3status-rust;
    license = licenses.gpl3;
    maintainers = [ maintainers.backuitist ];
    platforms = platforms.linux;
  };
}
