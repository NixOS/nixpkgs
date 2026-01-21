{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  autogen,
  pkg-config,
  python3,
  flac,
  lame,
  libmpg123,
  libogg,
  libopus,
  libvorbis,
  alsa-lib,

  # for passthru.tests
  audacity,
  freeswitch,
  gst_all_1,
  libsamplerate,
  moc,
  pipewire,
  pulseaudio,
}:

stdenv.mkDerivation rec {
  pname = "libsndfile";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "libsndfile";
    repo = "libsndfile";
    rev = version;
    hash = "sha256-MOOX/O0UaoeMaQPW9PvvE0izVp+6IoE5VbtTx0RvMkI=";
  };

  patches = [
    # Fix build with gcc15
    # https://github.com/libsndfile/libsndfile/pull/1055
    (fetchpatch {
      url = "https://github.com/libsndfile/libsndfile/commit/2251737b3b175925684ec0d37029ff4cb521d302.patch";
      hash = "sha256-LaeptEicnjpVBExlK4dNMlN8+AAJhW8dIvemF6S4W2M=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    autogen
    pkg-config
    python3
  ];
  buildInputs = [
    flac
    lame
    libmpg123
    libogg
    libopus
    libvorbis
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  enableParallelBuilding = true;

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
    "doc"
  ];

  # need headers from the Carbon.framework in /System/Library/Frameworks to
  # compile this on darwin -- not sure how to handle
  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    NIX_CFLAGS_COMPILE+=" -I$SDKROOT/System/Library/Frameworks/Carbon.framework/Versions/A/Headers"
  '';

  # Needed on Darwin.
  NIX_CFLAGS_LINK = "-logg -lvorbis";

  doCheck = true;
  preCheck = ''
    patchShebangs tests/test_wrapper.sh tests/pedantic-header-test.sh

    substituteInPlace tests/test_wrapper.sh \
      --replace '/usr/bin/env' "$(type -P env)"
  '';

  passthru.tests = {
    inherit
      audacity
      freeswitch
      libsamplerate
      moc
      pipewire
      pulseaudio
      ;
    inherit (python3.pkgs)
      soundfile
      wavefile
      ;
    inherit (gst_all_1) gst-plugins-bad;
    lame = (lame.override { sndfileFileIOSupport = true; });
  };

  meta = {
    description = "C library for reading and writing files containing sampled sound";
    homepage = "https://libsndfile.github.io/libsndfile/";
    changelog = "https://github.com/libsndfile/libsndfile/releases/tag/${version}";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ lovek323 ];
    platforms = lib.platforms.all;

    longDescription = ''
      Libsndfile is a C library for reading and writing files containing
      sampled sound (such as MS Windows WAV and the Apple/SGI AIFF format)
      through one standard library interface.  It is released in source
      code format under the GNU Lesser General Public License.

      The library was written to compile and run on a Linux system but
      should compile and run on just about any Unix (including macOS).
      There are also pre-compiled binaries available for 32 and 64 bit
      windows.

      It was designed to handle both little-endian (such as WAV) and
      big-endian (such as AIFF) data, and to compile and run correctly on
      little-endian (such as Intel and DEC/Compaq Alpha) processor systems
      as well as big-endian processor systems such as Motorola 68k, Power
      PC, MIPS and SPARC.  Hopefully the design of the library will also
      make it easy to extend for reading and writing new sound file
      formats.
    '';
  };
}
