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

stdenv.mkDerivation {
  pname = "dvgrab";
  version = "2016-05-16";

  src = fetchFromGitHub {
    # mirror of original project with some build fixes
    owner = "ddennedy";
    repo = "dvgrab";
    rev = "e46042e0c7b3523b6854ee547b0534e8310b7460";
    sha256 = "17qy76fjpzrbxm4pj0ljx5lbimxryv24fvr13jwkh24j85dxailn";
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

  meta = with lib; {
    description = "Receive and store audio & video over IEEE1394";

    longDescription = ''
      dvgrab receives audio and video data from a digital camcorder via an
      IEEE1394 (widely known as FireWire) or USB link and stores them into
      one of several file formats. It features autosplit of long video
      sequences, and supports saving the data as raw frames, AVI type 1,
      AVI type 2, Quicktime DV, a series of JPEG stills or MPEG2-TS.
    '';

    homepage = "https://github.com/ddennedy/dvgrab"; # Formerly http://www.kinodv.org/

    license = licenses.gpl2Plus;
    platforms = platforms.gnu ++ platforms.linux;
    mainProgram = "dvgrab";
  };
}
