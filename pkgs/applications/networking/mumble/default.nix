{ lib, stdenv, fetchFromGitHub, fetchpatch, pkg-config, qt5, cmake
, avahi, boost, libopus, libsndfile, protobuf, speex, libcap
, alsa-lib, python3
, rnnoise
, nixosTests
, poco
, flac
, libogg
, libvorbis
, grpcSupport ? false, grpc, which
, iceSupport ? true, zeroc-ice
, jackSupport ? false, libjack2
, pipewireSupport ? true, pipewire
, pulseSupport ? true, libpulseaudio
, speechdSupport ? false, speechd
}:

let
  generic = overrides: source: stdenv.mkDerivation (source // overrides // {
    pname = overrides.type;
    version = source.version;

    nativeBuildInputs = [ cmake pkg-config python3 qt5.wrapQtAppsHook qt5.qttools ]
      ++ (overrides.nativeBuildInputs or [ ]);

    buildInputs = [ avahi boost poco protobuf ]
      ++ (overrides.buildInputs or [ ]);

    cmakeFlags = [
      "-D g15=OFF"
    ] ++ (overrides.configureFlags or [ ]);

    preConfigure = ''
       patchShebangs scripts
    '';

    passthru.tests.connectivity = nixosTests.mumble;

    meta = with lib; {
      description = "Low-latency, high quality voice chat software";
      homepage = "https://mumble.info";
      license = licenses.bsd3;
      maintainers = with maintainers; [ infinisil felixsinger ];
      platforms = platforms.linux;
    };
  });

  client = source: generic {
    type = "mumble";

    nativeBuildInputs = [ qt5.qttools ];
    buildInputs = [ flac libogg libopus libsndfile libvorbis qt5.qtsvg rnnoise speex ]
      ++ lib.optional (!jackSupport) alsa-lib
      ++ lib.optional jackSupport libjack2
      ++ lib.optional speechdSupport speechd
      ++ lib.optional pulseSupport libpulseaudio
      ++ lib.optional pipewireSupport pipewire;

    configureFlags = [
      "-D server=OFF"
      "-D bundled-celt=ON"
      "-D bundled-opus=OFF"
      "-D bundled-speex=OFF"
      "-D bundled-rnnoise=OFF"
      "-D bundle-qt-translations=OFF"
      "-D update=OFF"
      "-D overlay-xcompile=OFF"
      "-D oss=OFF"
    ] ++ lib.optional (!speechdSupport) "-D speechd=OFF"
      ++ lib.optional (!pulseSupport) "-D pulseaudio=OFF"
      ++ lib.optional (!pipewireSupport) "-D pipewire=OFF"
      ++ lib.optional jackSupport "-D alsa=OFF -D jackaudio=ON";

    env.NIX_CFLAGS_COMPILE = lib.optionalString speechdSupport "-I${speechd}/include/speech-dispatcher";

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
      ]
      ++ lib.optional grpcSupport "-D grpc=ON";

    buildInputs = [ libcap ]
      ++ lib.optional iceSupport zeroc-ice
      ++ lib.optionals grpcSupport [ grpc which ];
  } source;

  source = rec {
    version = "1.4.287";

    # Needs submodules
    src = fetchFromGitHub {
      owner = "mumble-voip";
      repo = "mumble";
      rev = "5d808e287e99b402b724e411a7a0848e00956a24";
      sha256 = "sha256-SYsGCuj3HeyAQRUecGLaRdJR9Rm7lbaM54spY/zx0jU=";
      fetchSubmodules = true;
    };

    patches = [
      # fixes 'static assertion failed: static_assert(sizeof(CCameraAngles) == 0x408, "");'
      # when compiling pkgsi686Linux.mumble, which is a dependency of x64 mumble_overlay
      # https://github.com/mumble-voip/mumble/pull/5850
      # Remove with next version update
      (fetchpatch {
        url = "https://github.com/mumble-voip/mumble/commit/13c051b36b387356815cff5d685bc628b74ba136.patch";
        hash = "sha256-Rq8fb6NFd4DCNWm6OOMYIP7tBllufmQcB5CSxPU4qqg=";
      })
    ];
  };
in {
  mumble  = client source;
  murmur  = server source;
}
