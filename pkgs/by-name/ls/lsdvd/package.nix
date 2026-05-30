{
  lib,
  stdenv,
  fetchurl,
  libdvdread,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lsdvd";
  version = "0.17";
  src = fetchurl {
    url = "mirror://sourceforge/lsdvd/lsdvd-${finalAttrs.version}.tar.gz";
    sha256 = "1274d54jgca1prx106iyir7200aflr70bnb1kawndlmcckcmnb3x";
  };

  buildInputs = [ libdvdread ];
  nativeBuildInputs = [ pkg-config ];

  meta = {
    homepage = "https://sourceforge.net/projects/lsdvd/";
    description = "Display information about audio, video, and subtitle tracks on a DVD";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "lsdvd";
  };
})
