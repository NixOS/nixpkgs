{ lib, stdenv, fetchFromGitHub, pkg-config, qt5, cmake
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

    NIX_CFLAGS_COMPILE = lib.optional speechdSupport "-I${speechd}/include/speech-dispatcher";

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
    version = "unstable-1.4.231";

    # Needs submodules
    src = fetchFromGitHub {
      owner = "mumble-voip";
      repo = "mumble";
      rev = "9e0e274d6a9d8a9919267e747d05d0500d150560";
      sha256 = "0whvb4nlf7gjf2v7wsaq0ir18mshhw5wi8c9q9qz43wnh42nn2qi";
      fetchSubmodules = true;
    };
  };
in {
  mumble  = client source;
  murmur  = server source;
}
