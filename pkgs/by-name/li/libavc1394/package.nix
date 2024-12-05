{ lib, stdenv, fetchurl, pkg-config, libraw1394, argp-standalone }:

stdenv.mkDerivation rec {
  pname = "libavc1394";
  version = "0.5.4";

  src = fetchurl {
    url = "mirror://sourceforge/libavc1394/${pname}-${version}.tar.gz";
    sha256 = "0lsv46jdqvdx5hx92v0z2cz3yh6212pz9gk0k3513sbaa04zzcbw";
  };

  buildInputs = lib.optional stdenv.hostPlatform.isMusl argp-standalone;
  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ libraw1394 ];

  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isMusl "-largp";

  meta = {
    description = "Programming interface for the 1394 Trade Association AV/C (Audio/Video Control) Digital Interface Command Set";
    homepage = "https://sourceforge.net/projects/libavc1394/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
