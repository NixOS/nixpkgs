{ lib, stdenv, fetchurl , glib, pkg-config, libogg, libvorbis, libmad }:

stdenv.mkDerivation rec {
  pname = "streamripper";
  version = "1.64.6";

  src = fetchurl {
    url = "mirror://sourceforge/streamripper/${pname}-${version}.tar.gz";
    sha256 = "0hnyv3206r0rfprn3k7k6a0j959kagsfyrmyjm3gsf3vkhp5zmy1";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib libogg libvorbis libmad ];

  makeFlags = [
    "AR:=$(AR)"
  ];

  meta = with lib; {
    homepage = "https://streamripper.sourceforge.net/";
    description = "Application that lets you record streaming mp3 to your hard drive";
    license = licenses.gpl2;
    mainProgram = "streamripper";
  };
}
