{
  fetchFromGitHub,
  lib,
  stdenv,
  libunwind,
  libraw1394,
  libjpeg,
  libiec61883,
  libdv,
  libavc1394,
  pkg-config,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dvgrab";
  version = "3.5.2";

  src = fetchFromGitHub {
    # mirror of original project with some build fixes
    owner = "ddennedy";
    repo = "dvgrab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SAxI0jYSmNCwhz921nIhMcYVrpwsoX5YTO4qFrkcmeA=";
  };

  buildInputs = [
    libunwind
    libraw1394
    libjpeg
    libiec61883
    libdv
    libavc1394
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = {
    description = "Receive and store audio & video over IEEE1394";

    longDescription = ''
      dvgrab receives audio and video data from a digital camcorder via an
      IEEE1394 (widely known as FireWire) or USB link and stores them into
      one of several file formats. It features autosplit of long video
      sequences, and supports saving the data as raw frames, AVI type 1,
      AVI type 2, Quicktime DV, a series of JPEG stills or MPEG2-TS.
    '';

    homepage = "https://github.com/ddennedy/dvgrab"; # Formerly http://www.kinodv.org/

    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.gnu ++ lib.platforms.linux;
    mainProgram = "dvgrab";
    maintainers = [ lib.maintainers.ryand56 ];
  };
})
