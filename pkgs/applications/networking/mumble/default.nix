{ stdenv, fetchurl, fetchgit, pkgconfig
, qt4, qmake4Hook, qt5, avahi, boost, libopus, libsndfile, protobuf, speex, libcap
, alsaLib, python
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

    nativeBuildInputs = [ pkgconfig python ]
      ++ { qt4 = [ qmake4Hook ]; qt5 = [ qt5.qmake ]; }."qt${toString source.qtVersion}"
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
      ++ optional (!iceSupport) "CONFIG+=no-ice"
      ++ (overrides.configureFlags or [ ]);

    preConfigure = ''
       qmakeFlags="$qmakeFlags DEFINES+=PLUGIN_PATH=$out/lib"
       patchShebangs scripts
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
      homepage = http://mumble.sourceforge.net/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ viric jgeerds wkennington ];
      platforms = platforms.linux;
    };
  });

  client = source: generic {
    type = "mumble";

    nativeBuildInputs = optionals (source.qtVersion == 5) [ qt5.qttools ];
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

    buildInputs = [ libcap ] ++ optional iceSupport zeroc_ice;
  };

  stableSource = rec {
    version = "1.2.19";
    qtVersion = 4;

    src = fetchurl {
      url = "https://github.com/mumble-voip/mumble/releases/download/${version}/mumble-${version}.tar.gz";
      sha256 = "1s60vaici3v034jzzi20x23hsj6mkjlc0glipjq4hffrg9qgnizh";
    };
  };

  gitSource = rec {
    version = "2017-05-25";
    qtVersion = 5;

    # Needs submodules
    src = fetchgit {
      url = "https://github.com/mumble-voip/mumble";
      rev = "3754898ac94ed3f1e86408114917d1b4c06f17b3";
      sha256 = "1qh49x3y7m0c0h0gcs6amkf8nb75p6g611zwn19mbplwmi7h9y8f";
    };
  };
in {
  mumble     = client stableSource;
  mumble_git = client gitSource;
  murmur     = server stableSource;
  murmur_git = (server gitSource).overrideAttrs (old: {
    meta = old.meta // { broken = iceSupport; };
  });
}
