{ stdenv, fetchsvn, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "gpac-0.5.0-svn";

  src = fetchsvn {
    url = "https://gpac.svn.sourceforge.net/svnroot/gpac/trunk/gpac";
    rev = "4253";
    sha256 = "0z4bd63c805q53hpb09gq0m0apy12z5a90zxx4jjx3ln64xq0pnn";
  };

  # this is the bare minimum configuration, as I'm only interested in MP4Box
  # For most other functionality, this should probably be extended
  nativeBuildInputs = [ pkgconfig zlib ];

  meta = {
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
    homepage = http://gpac.wp.mines-telecom.fr;
    license = stdenv.lib.licenses.lgpl21;

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = stdenv.lib.platforms.all;
  };
}
