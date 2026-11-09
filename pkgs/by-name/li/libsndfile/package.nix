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

stdenv.mkDerivation (finalAttrs: {
  pname = "libsndfile";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "libsndfile";
    repo = "libsndfile";
    rev = finalAttrs.version;
    hash = "sha256-MOOX/O0UaoeMaQPW9PvvE0izVp+6IoE5VbtTx0RvMkI=";
  };

  patches = [
    # Fix build with gcc15
    # https://github.com/libsndfile/libsndfile/pull/1055
    (fetchpatch {
      url = "https://github.com/libsndfile/libsndfile/commit/2251737b3b175925684ec0d37029ff4cb521d302.patch";
      hash = "sha256-LaeptEicnjpVBExlK4dNMlN8+AAJhW8dIvemF6S4W2M=";
    })
    # Fix an out-of-bounds read in `vorbis_analysis_wrote` (CVE-2024-50612)
    # https://github.com/libsndfile/libsndfile/pull/1045
    (fetchpatch {
      name = "CVE-2024-50612.patch";
      url = "https://github.com/libsndfile/libsndfile/commit/4755f5bd7854611d92ad0f1295587b439f9950ba.patch";
      hash = "sha256-PtDNAOxzy0f6YmK84uznh+3qQF3bbbKeZTNCs0I7lXA=";
    })
    # Fix integer overflows in the IMA ADPCM codec.
    # The first patch fixes the AIFF path and is a part of the CVE-2022-33065 fixes.
    # The second patch fixes the WAV and close paths (CVE-2026-37555).
    # https://github.com/libsndfile/libsndfile/pull/979
    (fetchpatch {
      name = "ima-adpcm-int-overflow-aiff.patch";
      url = "https://github.com/libsndfile/libsndfile/commit/9a829113c88a51e57c1e46473e90609e4b7df151.patch";
      hash = "sha256-gUCNPSj/F5M9QhkSPwhFV7r0tm9eIWSzEltWtIp/3cE=";
    })
    # https://github.com/libsndfile/libsndfile/pull/1123
    (fetchpatch {
      name = "CVE-2026-37555.patch";
      url = "https://github.com/libsndfile/libsndfile/commit/cdadf9a65fdc1f28da9d235eb443d5f5e57010d2.patch";
      hash = "sha256-GxyE9rYHFVT0RXjHYzHyrooqboa9SZKIR8kw1oEHffI=";
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

  strictDeps = true;

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
  env.NIX_CFLAGS_LINK = toString [
    "-logg"
    "-lvorbis"
  ];

  # Broken with libopus >= 1.6.0
  doCheck = false;
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

  __structuredAttrs = true;

  meta = {
    description = "C library for reading and writing files containing sampled sound";
    homepage = "https://libsndfile.github.io/libsndfile/";
    changelog = "https://github.com/libsndfile/libsndfile/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ ];
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
})
