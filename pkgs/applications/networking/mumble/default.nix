{ stdenv, fetchurl, fetchgit, pkgconfig
, qt4, qmake4Hook, qt5, avahi, boost, libopus, libsndfile, protobuf, speex, libcap
, alsaLib
, jackSupport ? false, libjack2 ? null
, speechdSupport ? false, speechd ? null
, pulseSupport ? false, libpulseaudio ? null
, iceSupport ? false, zeroc_ice ? null
}:

assert jackSupport -> libjack2 != null;
assert speechdSupport -> speechd != null;
assert pulseSupport -> libpulseaudio != null;
assert iceSupport -> zeroc_ice != null;

with stdenv.lib;
let
  generic = overrides: source: stdenv.mkDerivation (source // overrides // {
    name = "${overrides.type}-${source.version}";

    patches = optional jackSupport ./mumble-jack-support.patch;

    nativeBuildInputs = [ pkgconfig ]
      ++ { qt4 = [ qmake4Hook ]; qt5 = [ qt5.qmakeHook ]; }."qt${toString source.qtVersion}"
      ++ (overrides.nativeBuildInputs or [ ]);
    buildInputs = [ boost protobuf avahi ]
      ++ { qt4 = [ qt4 ]; qt5 = [ qt5.qtbase ]; }."qt${toString source.qtVersion}"
      ++ (overrides.buildInputs or [ ]);

    qmakeFlags = [
      "CONFIG+=shared"
      "CONFIG+=no-g15"
      "CONFIG+=packaged"
      "CONFIG+=no-update"
      "CONFIG+=no-embed-qt-translations"
      "CONFIG+=bundled-celt"
      "CONFIG+=no-bundled-opus"
      "CONFIG+=no-bundled-speex"
    ] ++ optional (!speechdSupport) "CONFIG+=no-speechd"
      ++ optional jackSupport "CONFIG+=no-oss CONFIG+=no-alsa CONFIG+=jackaudio"
      ++ (overrides.configureFlags or [ ]);

    preConfigure = ''
       qmakeFlags="$qmakeFlags DEFINES+=PLUGIN_PATH=$out/lib"
    '';

    makeFlags = [ "release" ];

    installPhase = ''
      mkdir -p $out/{lib,bin}
      find release -type f -not -name \*.\* -exec cp {} $out/bin \;
      find release -type f -name \*.\* -exec cp {} $out/lib \;

      mkdir -p $out/share/man/man1
      cp man/mum* $out/share/man/man1
    '' + (overrides.installPhase or "");

    enableParallelBuilding = true;

    meta = {
      description = "Low-latency, high quality voice chat software";
      homepage = "http://mumble.sourceforge.net/";
      license = licenses.bsd3;
      maintainers = with maintainers; [ viric jgeerds wkennington ];
      platforms = platforms.linux;
    };
  });

  client = source: generic {
    type = "mumble";

    nativeBuildInputs = optional (source.qtVersion == 5) qt5.qttools;
    buildInputs = [ libopus libsndfile speex ]
      ++ optional (source.qtVersion == 5) qt5.qtsvg
      ++ optional stdenv.isLinux alsaLib
      ++ optional jackSupport libjack2
      ++ optional speechdSupport speechd
      ++ optional pulseSupport libpulseaudio;

    configureFlags = [
      "CONFIG+=no-server"
    ];

    NIX_CFLAGS_COMPILE = optional speechdSupport "-I${speechd}/include/speech-dispatcher";

    installPhase = ''
      mkdir -p $out/share/applications
      cp scripts/mumble.desktop $out/share/applications

      mkdir -p $out/share/icons{,/hicolor/scalable/apps}
      cp icons/mumble.svg $out/share/icons
      ln -s $out/share/icon/mumble.svg $out/share/icons/hicolor/scalable/apps
    '';
  } source;

  server = generic {
    type = "murmur";

    postPatch = optional iceSupport ''
      grep -Rl '/usr/share/Ice' . | xargs sed -i 's,/usr/share/Ice/,${zeroc_ice}/,g'
    '';

    configureFlags = [
      "CONFIG+=no-client"
    ];

    buildInputs = [ libcap ] ++ optional iceSupport [ zeroc_ice ];
  };

  stableSource = rec {
    version = "1.2.15";
    qtVersion = 4;

    src = fetchurl {
      url = "https://github.com/mumble-voip/mumble/releases/download/${version}/mumble-${version}.tar.gz";
      sha256 = "1yjywzybgq23ry5s2yihggs13ffrphhwl6rlp6lq79rkwvafa9v5";
    };
  };

  gitSource = rec {
    version = "1.3.0-git-2016-04-10";
    qtVersion = 5;

    # Needs submodules
    src = fetchgit {
      url = "https://github.com/mumble-voip/mumble";
      rev = "0502fa67b036bae9f07a586d9f05a8bf74c24291";
      sha256 = "073v8nway17j1n1lm70x508722b1q3vb6h4fvmcbbma3d22y1h45";
    };
  };
in {
  mumble     = client stableSource;
  mumble_git = client gitSource;
  murmur     = server stableSource;
  murmur_git = server gitSource;
}
