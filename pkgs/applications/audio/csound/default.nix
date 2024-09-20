{ lib, stdenv, fetchFromGitHub, cmake, libsndfile, libsamplerate, flex, bison, boost, gettext
, Accelerate
, AudioUnit
, CoreAudio
, CoreMIDI
, portaudio
, alsa-lib ? null
, libpulseaudio ? null
, libjack2 ? null
, liblo ? null
, ladspa-sdk ? null
, curl ? null
}:

stdenv.mkDerivation rec {
  pname = "csound";
  version = "6.18.1";

  hardeningDisable = [ "format" ];

  src = fetchFromGitHub {
    owner = "csound";
    repo = "csound";
    rev = version;
    sha256 = "sha256-O7s92N54+zIl07eIdK/puoSve/qJ3O01fTh0TP+VdZA=";
  };

  cmakeFlags = lib.optional stdenv.isAarch32 (lib.cmakeFeature "CMAKE_C_FLAGS" "-DPFFFT_SIMD_DISABLE")
    ++ lib.optional stdenv.isDarwin "-DCS_FRAMEWORK_DEST=${placeholder "out"}/lib"
    # Ignore gettext in CMAKE_PREFIX_PATH on cross to prevent find_program picking up the wrong gettext
    ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "-DCMAKE_IGNORE_PATH=${lib.getBin gettext}/bin";

  nativeBuildInputs = [ cmake flex bison gettext ];
  buildInputs = [ libsndfile libsamplerate boost curl ]
    ++ lib.optionals stdenv.isDarwin [
      Accelerate AudioUnit CoreAudio CoreMIDI portaudio
    ] ++ lib.optionals stdenv.isLinux [
      alsa-lib libpulseaudio libjack2
      liblo ladspa-sdk
    ];

  postInstall = lib.optional stdenv.isDarwin ''
    mkdir -p $out/Library/Frameworks
    ln -s $out/lib/CsoundLib64.framework $out/Library/Frameworks
  '';

  meta = with lib; {
    description = "Sound design, audio synthesis, and signal processing system, providing facilities for music composition and performance on all major operating systems and platforms";
    homepage = "https://csound.com/";
    license = licenses.lgpl21Plus;
    maintainers = [maintainers.marcweber];
    platforms = platforms.unix;
  };
}
