{ lib, stdenv, fetchFromGitHub, pkg-config, qt5
, avahi, boost, libopus, libsndfile, protobuf, speex, libcap
, alsa-lib, python3
, rnnoise
, jackSupport ? false, libjack2
, speechdSupport ? false, speechd
, pulseSupport ? false, libpulseaudio
, iceSupport ? false, zeroc-ice
, grpcSupport ? false, grpc, which
, nixosTests
}:

let
  generic = overrides: source: qt5.mkDerivation (source // overrides // {
    pname = overrides.type;
    version = source.version;

    patches = (source.patches or [])
      ++ [ ./fix-rnnoise-argument.patch ];

    nativeBuildInputs = [ pkg-config python3 qt5.qmake ]
      ++ (overrides.nativeBuildInputs or [ ]);

    buildInputs = [ boost protobuf avahi ]
      ++ (overrides.buildInputs or [ ]);

    qmakeFlags = [
      "CONFIG+=c++11"
      "CONFIG+=shared"
      "CONFIG+=no-g15"
      "CONFIG+=packaged"
      "CONFIG+=no-update"
      "CONFIG+=no-embed-qt-translations"
      "CONFIG+=bundled-celt"
      "CONFIG+=no-bundled-opus"
      "CONFIG+=no-bundled-speex"
      "DEFINES+=PLUGIN_PATH=${placeholder "out"}/lib/mumble"
    ] ++ lib.optional (!speechdSupport) "CONFIG+=no-speechd"
      ++ lib.optional jackSupport "CONFIG+=no-oss CONFIG+=no-alsa CONFIG+=jackaudio"
      ++ (overrides.configureFlags or [ ]);

    preConfigure = ''
       patchShebangs scripts
    '';

    makeFlags = [ "release" ];

    installPhase = ''
      runHook preInstall

      ${overrides.installPhase}

      # doc stuff
      mkdir -p $out/share/man/man1
      install -Dm644 man/mum* $out/share/man/man1/

      runHook postInstall
    '';

    passthru.tests.connectivity = nixosTests.mumble;

    meta = with lib; {
      description = "Low-latency, high quality voice chat software";
      homepage = "https://mumble.info";
      license = licenses.bsd3;
      maintainers = with maintainers; [ petabyteboy infinisil felixsinger ];
      platforms = platforms.linux;
    };
  });

  client = source: generic {
    type = "mumble";

    nativeBuildInputs = [ qt5.qttools ];
    buildInputs = [ libopus libsndfile speex qt5.qtsvg rnnoise ]
      ++ lib.optional stdenv.isLinux alsa-lib
      ++ lib.optional jackSupport libjack2
      ++ lib.optional speechdSupport speechd
      ++ lib.optional pulseSupport libpulseaudio;

    configureFlags = [
      "CONFIG+=no-server"
    ];

    NIX_CFLAGS_COMPILE = lib.optional speechdSupport "-I${speechd}/include/speech-dispatcher";

    installPhase = ''
      # bin stuff
      install -Dm755 release/mumble $out/bin/mumble
      install -Dm755 scripts/mumble-overlay $out/bin/mumble-overlay

      # lib stuff
      mkdir -p $out/lib/mumble
      cp -P release/libmumble.so* $out/lib
      cp -P release/libcelt* $out/lib/mumble
      cp -P release/plugins/* $out/lib/mumble

      # icons
      install -Dm644 scripts/mumble.desktop $out/share/applications/mumble.desktop
      install -Dm644 icons/mumble.svg $out/share/icons/hicolor/scalable/apps/mumble.svg
    '';
  } source;

  server = source: generic {
    type = "murmur";

    postPatch = lib.optionalString iceSupport ''
      grep -Rl '/usr/share/Ice' . | xargs sed -i 's,/usr/share/Ice/,${zeroc-ice.dev}/share/ice/,g'
    '';

    configureFlags = [
      "CONFIG+=no-client"
    ] ++ lib.optional (!iceSupport) "CONFIG+=no-ice"
      ++ lib.optional grpcSupport "CONFIG+=grpc";

    buildInputs = [ libcap ]
      ++ lib.optional iceSupport zeroc-ice
      ++ lib.optionals grpcSupport [ grpc which ];

    installPhase = ''
      # bin stuff
      install -Dm755 release/murmurd $out/bin/murmurd
    '';
  } source;

  source = rec {
    version = "1.3.4";

    # Needs submodules
    src = fetchFromGitHub {
      owner = "mumble-voip";
      repo = "mumble";
      rev = version;
      sha256 = "sha256-njovShQpW0JNeeE8VugdmGzDk3fKG8/fcJoBgdyTZug=";
      fetchSubmodules = true;
    };
  };
in {
  mumble  = client source;
  murmur  = server source;
}
