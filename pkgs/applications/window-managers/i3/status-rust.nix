{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, dbus, gperftools }:

rustPlatform.buildRustPackage rec {
  name = "i3status-rust-${version}";
  version = "0.9.0.2018-06-22";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = "i3status-rust";
    rev = "fdca01e88a7ce9bf4de0f58a922de5131e33dd00";
    sha256 = "12dfvamf9a13b3fa7mqrwhjk3rl53463h03arqd8pvbch006hhqd";
  };

  cargoSha256 = "01pwknfzkv49cip6asqd4pzkh9l42v06abyd9lb09ip5pkcs60lq";

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
