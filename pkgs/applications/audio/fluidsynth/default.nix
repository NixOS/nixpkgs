{ stdenv, lib, fetchFromGitHub, fetchpatch, buildPackages, pkg-config, cmake
, alsa-lib, glib, libjack2, libsndfile, libpulseaudio
, AppKit, AudioUnit, CoreAudio, CoreMIDI, CoreServices
}:

stdenv.mkDerivation rec {
  pname = "fluidsynth";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "FluidSynth";
    repo = "fluidsynth";
    rev = "v${version}";
    sha256 = "sha256-BSJu3jB7b5G2ThXBUHUNnBGl55EXe3nIzdBdgfOWDSM=";
  };

  patches = [
    # Fixes bad CMAKE_INSTALL_PREFIX + CMAKE_INSTALL_LIBDIR concatenation for Darwin install name dir
    # Remove when PR merged & in release
    (fetchpatch {
      name = "0001-Fix-incorrect-way-of-turning-CMAKE_INSTALL_LIBDIR-absolute.patch";
      url = "https://github.com/FluidSynth/fluidsynth/pull/1261/commits/03cd38dd909fc24aa39553d869afbb4024416de8.patch";
      hash = "sha256-nV+MbFttnbNBO4zWnPLpnnEuoiESkV9BGFlUS9tQQfk=";
    })
  ];

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = [ buildPackages.stdenv.cc pkg-config cmake ];

  buildInputs = [ glib libsndfile libjack2 ]
    ++ lib.optionals stdenv.isLinux [ alsa-lib libpulseaudio ]
    ++ lib.optionals stdenv.isDarwin [ AppKit AudioUnit CoreAudio CoreMIDI CoreServices ];

  cmakeFlags = [
    "-Denable-framework=off"
  ];

  meta = with lib; {
    description = "Real-time software synthesizer based on the SoundFont 2 specifications";
    homepage    = "https://www.fluidsynth.org";
    license     = licenses.lgpl21Plus;
    maintainers = with maintainers; [ goibhniu lovek323 ];
    platforms   = platforms.unix;
  };
}
