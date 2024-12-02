{ lib, stdenv, fetchFromGitHub, fetchpatch, pkg-config, qt5, cmake
, avahi, boost, libopus, libsndfile, protobuf, speex, libcap
, alsa-lib, python3
, rnnoise
, nixosTests
, poco
, flac
, libogg
, libvorbis
, stdenv_32bit
, iceSupport ? true, zeroc-ice
, jackSupport ? false, libjack2
, pipewireSupport ? true, pipewire
, pulseSupport ? true, libpulseaudio
, speechdSupport ? false, speechd-minimal
}:

let
  generic = overrides: source: (overrides.stdenv or stdenv).mkDerivation (source // overrides // {
    pname = overrides.type;
    version = source.version;

    nativeBuildInputs = [ cmake pkg-config python3 qt5.wrapQtAppsHook qt5.qttools ]
      ++ (overrides.nativeBuildInputs or [ ]);

    buildInputs = [ avahi boost poco protobuf ]
      ++ (overrides.buildInputs or [ ]);

    cmakeFlags = [
      "-D g15=OFF"
      "-D CMAKE_CXX_STANDARD=17" # protobuf >22 requires C++ 17
    ] ++ (overrides.configureFlags or [ ]);

    preConfigure = ''
       patchShebangs scripts
    '';

    passthru.tests.connectivity = nixosTests.mumble;

    meta = with lib; {
      description = "Low-latency, high quality voice chat software";
      homepage = "https://mumble.info";
      license = licenses.bsd3;
      maintainers = with maintainers; [ felixsinger lilacious ];
      platforms = platforms.linux;
    };
  });

  client = source: generic {
    type = "mumble";

    nativeBuildInputs = [ qt5.qttools ];
    buildInputs = [ flac libogg libopus libsndfile libvorbis qt5.qtsvg rnnoise speex ]
      ++ lib.optional (!jackSupport) alsa-lib
      ++ lib.optional jackSupport libjack2
      ++ lib.optional speechdSupport speechd-minimal
      ++ lib.optional pulseSupport libpulseaudio
      ++ lib.optional pipewireSupport pipewire;

    configureFlags = [
      "-D server=OFF"
      "-D bundled-celt=ON"
      "-D bundled-opus=OFF"
      "-D bundled-speex=OFF"
      "-D bundle-qt-translations=OFF"
      "-D update=OFF"
      "-D overlay-xcompile=OFF"
      "-D oss=OFF"
      "-D warnings-as-errors=OFF" # conversion error workaround
    ] ++ lib.optional (!speechdSupport) "-D speechd=OFF"
      ++ lib.optional (!pulseSupport) "-D pulseaudio=OFF"
      ++ lib.optional (!pipewireSupport) "-D pipewire=OFF"
      ++ lib.optional jackSupport "-D alsa=OFF -D jackaudio=ON";

    env.NIX_CFLAGS_COMPILE = lib.optionalString speechdSupport "-I${speechd-minimal}/include/speech-dispatcher";

    postFixup = ''
      wrapProgram $out/bin/mumble \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath (lib.optional pulseSupport libpulseaudio ++ lib.optional pipewireSupport pipewire)}"
    '';
  } source;

  server = source: generic {
    type = "murmur";

    configureFlags = [
      "-D client=OFF"
    ] ++ lib.optional (!iceSupport) "-D ice=OFF"
      ++ lib.optionals iceSupport [
        "-D Ice_HOME=${lib.getDev zeroc-ice};${lib.getLib zeroc-ice}"
        "-D CMAKE_PREFIX_PATH=${lib.getDev zeroc-ice};${lib.getLib zeroc-ice}"
        "-D Ice_SLICE_DIR=${lib.getDev zeroc-ice}/share/ice/slice"
      ];

    buildInputs = [ libcap ]
      ++ lib.optional iceSupport zeroc-ice;
  } source;

  overlay = source: generic {
    stdenv = stdenv_32bit;
    type = "mumble-overlay";

    configureFlags = [
      "-D server=OFF"
      "-D client=OFF"
      "-D overlay=ON"
    ];
  } source;

  source = rec {
    version = "1.5.634";

    # Needs submodules
    src = fetchFromGitHub {
      owner = "mumble-voip";
      repo = "mumble";
      rev = "v${version}";
      hash = "sha256-d9XmXHq264rTT80zphYcKLxS+AyUhjb19D3DuBJvMI4=";
      fetchSubmodules = true;
    };

    patches = [
      (fetchpatch {
        name = "GCC14.patch";
        url = "https://github.com/mumble-voip/mumble/commit/56945a9dfb62d29dccfe561572ebf64500deaed1.patch";
        hash = "sha256-Frct9XJ/ZuHPglx+GB9h3vVycR8YY039dStIbfkPPDk=";
      })
    ];
  };
in {
  mumble  = lib.recursiveUpdate (client source) {meta.mainProgram = "mumble";};
  murmur  = lib.recursiveUpdate (server source) {meta.mainProgram = "mumble-server";};
  overlay = overlay source;
}
