{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, dbus, gperftools }:

rustPlatform.buildRustPackage rec {
  name = "i3status-rust-${version}";
  version = "0.9.0.2018-09-30";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = "i3status-rust";
    rev = "82ea033250c3fc51a112ac68c389da5264840492";
    sha256 = "06r1nnv3a5vq3s17rgavq639wrq09z0nd2ck50bj1c8i2ggkpvq9";
  };

  cargoSha256 = "02in0hz2kgbmrd8i8s21vbm9pgfnn4axcji5f2a14pha6lx5rnvv";

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
