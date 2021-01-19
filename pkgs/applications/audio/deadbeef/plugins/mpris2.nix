{ lib, stdenv, fetchurl, pkg-config, deadbeef, glib }:

stdenv.mkDerivation rec {
  pname = "deadbeef-mpris2-plugin";
  version = "1.12";

  src = fetchurl {
    url = "https://github.com/Serranya/deadbeef-mpris2-plugin/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "0s3y4ka4qf38cypc0xspy79q0g5y1kqx6ldad7yr6a45nw6j95jh";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ deadbeef glib ];

  meta = with lib; {
    description = "MPRISv2 plugin for the DeaDBeeF music player";
    homepage = "https://github.com/Serranya/deadbeef-mpris2-plugin/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.abbradar ];
  };
}
