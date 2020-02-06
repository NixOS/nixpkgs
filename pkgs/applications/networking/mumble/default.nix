{ stdenv, fetchurl, fetchFromGitHub, fetchpatch, pkgconfig, qt5
, avahi, boost, libopus, libsndfile, protobuf, speex, libcap
, alsaLib, python
, rnnoise
, jackSupport ? false, libjack2 ? null
, speechdSupport ? false, speechd ? null
, pulseSupport ? false, libpulseaudio ? null
, iceSupport ? false, zeroc-ice ? null
}:

assert jackSupport -> libjack2 != null;
assert speechdSupport -> speechd != null;
assert pulseSupport -> libpulseaudio != null;
assert iceSupport -> zeroc-ice != null;

with stdenv.lib;
let
  generic = overrides: source: qt5.mkDerivation (source // overrides // {
    pname = overrides.type;
    version = source.version;

    patches = (source.patches or []) ++ optional jackSupport ./mumble-jack-support.patch;

    nativeBuildInputs = [ pkgconfig python qt5.qmake ]
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
    ] ++ optional (!speechdSupport) "CONFIG+=no-speechd"
      ++ optional jackSupport "CONFIG+=no-oss CONFIG+=no-alsa CONFIG+=jackaudio"
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

    enableParallelBuilding = true;

    meta = {
      description = "Low-latency, high quality voice chat software";
      homepage = "https://mumble.info";
      license = licenses.bsd3;
      maintainers = with maintainers; [ petabyteboy infinisil ];
      platforms = platforms.linux;
    };
  });

  client = source: generic {
    type = "mumble";

    nativeBuildInputs = [ qt5.qttools ];
    buildInputs = [ libopus libsndfile speex qt5.qtsvg rnnoise ]
      ++ optional stdenv.isLinux alsaLib
      ++ optional jackSupport libjack2
      ++ optional speechdSupport speechd
      ++ optional pulseSupport libpulseaudio;

    configureFlags = [
      "CONFIG+=no-server"
    ];

    NIX_CFLAGS_COMPILE = optional speechdSupport "-I${speechd}/include/speech-dispatcher";

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

    postPatch = optional iceSupport ''
      grep -Rl '/usr/share/Ice' . | xargs sed -i 's,/usr/share/Ice/,${zeroc-ice.dev}/share/ice/,g'
    '';

    configureFlags = [
      "CONFIG+=no-client"
    ] ++ optional (!iceSupport) "CONFIG+=no-ice";

    buildInputs = [ libcap ] ++ optional iceSupport zeroc-ice;

    installPhase = ''
      # bin stuff
      install -Dm755 release/murmurd $out/bin/murmurd
    '';
  } source;

  source = rec {
    version = "1.3.0";

    # Needs submodules
    src = fetchFromGitHub {
      owner = "mumble-voip";
      repo = "mumble";
      rev = version;
      sha256 = "0g5ri84gg0x3crhpxlzawf9s9l4hdna6aqw6qbdpx1hjlf5k6g8k";
      fetchSubmodules = true;
    };
  };
in {
  mumble  = client source;
  murmur  = server source;
}
