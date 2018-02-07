{ stdenv, fetchFromGitHub, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  version = "0.7.1";
  name = "gpac-${version}";

  src = fetchFromGitHub {
    owner = "gpac";
    repo = "gpac";
    rev = "v${version}";
    sha256 = "197c5968p5bzvk0ga347fwgkqh4j1v3z65wlx65c5m9gwfxz2k2q";
  };

  # this is the bare minimum configuration, as I'm only interested in MP4Box
  # For most other functionality, this should probably be extended
  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ zlib ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Open Source multimedia framework for research and academic purposes";
    longDescription = ''
      GPAC is an Open Source multimedia framework for research and academic purposes.
      The project covers different aspects of multimedia, with a focus on presentation
      technologies (graphics, animation and interactivity) and on multimedia packaging
      formats such as MP4.

      GPAC provides three sets of tools based on a core library called libgpac:

      A multimedia player, called Osmo4 / MP4Client,
      A multimedia packager, called MP4Box,
      And some server tools included in MP4Box and MP42TS applications.
    '';
    homepage = https://gpac.wp.imt.fr;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ bluescreen303 mgdelacroix ];
    platforms = platforms.linux;
  };
}
