{ stdenv, fetchurl, fetchFromGitHub, fetchpatch, pkgconfig
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

    patches = (source.patches or []) ++ optional jackSupport ./mumble-jack-support.patch;

    nativeBuildInputs = [ pkgconfig python ]
      ++ { qt4 = [ qmake4Hook ]; qt5 = [ qt5.qmake ]; }."qt${toString source.qtVersion}"
      ++ (overrides.nativeBuildInputs or [ ]);
    buildInputs = [ boost protobuf avahi ]
      ++ { qt4 = [ qt4 ]; qt5 = [ qt5.qtbase ]; }."qt${toString source.qtVersion}"
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
      homepage = https://mumble.info;
      license = licenses.bsd3;
      maintainers = with maintainers; [ jgeerds ];
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
      ln -s $out/share/icons/mumble.svg $out/share/icons/hicolor/scalable/apps
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

    patches = [
      # Fix compile error against boost 1.66 (#33655):
      (fetchpatch {
        url = "https://github.com/mumble-voip/mumble/commit/"
            + "ea861fe86743c8402bbad77d8d1dd9de8dce447e.patch";
        sha256 = "1r50dc8dcl6jmbj4abhnay9div7y56kpmajzqd7ql0pm853agwbh";
      })
      # Fixes hang on reconfiguring audio (often including startup)
      # https://github.com/mumble-voip/mumble/pull/3418
      (fetchpatch {
        url = "https://github.com/mumble-voip/mumble/commit/"
            + "fbbdf2e8ab7d93ed6f7680268ad0689b7eaa71ad.patch";
        sha256 = "1yhj62mlwm6q42i4aclbia645ha97d3j4ycxhgafr46dbjs0gani";
      })
    ];
  };

  gitSource = rec {
    version = "2018-07-01";
    qtVersion = 5;

    # Needs submodules
    src = fetchFromGitHub {
      owner = "mumble-voip";
      repo = "mumble";
      rev = "c19ac8c0b0f934d2ff206858d7cb66352d6eb418";
      sha256 = "1mzp1bgn49ycs16d6r8icqq35wq25198fs084vyq6j5f78ni7pvz";
      fetchSubmodules = true;
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
