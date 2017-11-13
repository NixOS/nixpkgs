{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, dbus_libs }:

with rustPlatform;

buildRustPackage rec {
  name = "i3status-rust-${version}";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = "i3status-rust";
    rev = "5daf2cdd611bed3db804d011d5d5af34b558e615";
    sha256 = "0j6h7x5mm3m7wq0if20qxc9z3qw29xgf5qb3sqwdbdpz8ykpqdgk";
  };

  buildInputs = [ dbus_libs ];

  nativeBuildInputs = [ pkgconfig ];

  doCheck = false;

  cargoSha256 = "1197hp6d4z14j0r22bvw9ly294li0ivg6yfql4lgi27hbvzag71h";

  meta = with stdenv.lib; {
    description = "Very resource-friendly and feature-rich replacement for i3status, written in Rust";
    homepage = https://github.com/greshake/i3status-rust;
    license = licenses.gpl3;
    maintainers = [ maintainers.tailhook ];
    platforms = platforms.all;
  };
}

