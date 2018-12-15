{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, dbus }:

rustPlatform.buildRustPackage rec {
  name = "i3status-rust-${version}";
  version = "0.9.0.2018-10-02";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = "i3status-rust";
    rev = "11c2a21693ffcd0b6c2e0ac919b2232918293963";
    sha256 = "019m9qpw7djq6g7lzbm7gjcavlgsp93g3cd7cb408nxnfsi7i9dp";
  };

  cargoSha256 = "1wnify730f7c3cb8wllqvs7pzrq54g5x81xspvz5gq0iqr0q38zc";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ dbus ];

  meta = with stdenv.lib; {
    description = "Very resource-friendly and feature-rich replacement for i3status";
    homepage = https://github.com/greshake/i3status-rust;
    license = licenses.gpl3;
    maintainers = [ maintainers.backuitist ];
    platforms = platforms.linux;
  };
}
