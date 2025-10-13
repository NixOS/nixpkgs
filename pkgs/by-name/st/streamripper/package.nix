{
  lib,
  stdenv,
  fetchurl,
  fetchDebianPatch,
  glib,
  pkg-config,
  libogg,
  libvorbis,
  libmad,
}:

stdenv.mkDerivation rec {
  pname = "streamripper";
  version = "1.64.6";

  src = fetchurl {
    url = "mirror://sourceforge/streamripper/${pname}-${version}.tar.gz";
    sha256 = "0hnyv3206r0rfprn3k7k6a0j959kagsfyrmyjm3gsf3vkhp5zmy1";
  };

  patches = [
    # fix build with gcc 14
    (fetchDebianPatch {
      inherit pname version;
      debianRevision = "2";
      patch = "1075541-gcc14";
      hash = "sha256-30bz7CDmbq+Bd+jTKSq7aJsXUJQAQp3nnJZvt3Qbp8Q=";
    })
    # fix parse of URIs containing colons (https://bugs.debian.org/873964)
    (fetchDebianPatch {
      inherit pname version;
      debianRevision = "2";
      patch = "873964-http";
      hash = "sha256-D6koUCbnJHtRuq2zZy9VrxymuGXN1COacbQhphgB8qo=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    libogg
    libvorbis
    libmad
  ];

  meta = with lib; {
    homepage = "https://streamripper.sourceforge.net/";
    description = "Application that lets you record streaming mp3 to your hard drive";
    license = licenses.gpl2;
    mainProgram = "streamripper";
  };
}
