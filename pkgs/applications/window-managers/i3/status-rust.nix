{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, dbus, libpulseaudio }:

rustPlatform.buildRustPackage rec {
  pname = "i3status-rust";
  version = "0.9.0.2019-04-27";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = pname;
    rev = "d04d08cbd4d13c64b1e3b7a8d21c46acee3bc281";
    sha256 = "0x23qv7kwsqy1yx25fn1z56fx8w865qarr5xdx8s22x42ym4zyha";
  };

  cargoSha256 = "0vl2zn9n7ijmjxi2lyglnghvaw4qi2bah5i6km15schlsm8c641g";

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
