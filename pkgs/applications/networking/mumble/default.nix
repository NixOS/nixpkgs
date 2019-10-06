{ stdenv, fetchurl, fetchFromGitHub, fetchpatch, pkgconfig
, qt4, qmake4Hook, qt5, avahi, boost, libopus, libsndfile, protobuf3_6, speex, libcap
, alsaLib, python
, jackSupport ? false, libjack2 ? null
, speechdSupport ? false, speechd ? null
, pulseSupport ? false, libpulseaudio ? null
, iceSupport ? false, zeroc-ice ? null, zeroc-ice-36 ? null
}:

assert jackSupport -> libjack2 != null;
assert speechdSupport -> speechd != null;
assert pulseSupport -> libpulseaudio != null;
assert iceSupport -> zeroc-ice != null && zeroc-ice-36 != null;

with stdenv.lib;
let
  generic = overrides: source: (if source.qtVersion == 5 then qt5.mkDerivation else stdenv.mkDerivation) (source // overrides // {
    name = "${overrides.type}-${source.version}";

    patches = (source.patches or []) ++ optional jackSupport ./mumble-jack-support.patch;

    nativeBuildInputs = [ pkgconfig python ]
      ++ { qt4 = [ qmake4Hook ]; qt5 = [ qt5.qmake ]; }."qt${toString source.qtVersion}"
      ++ (overrides.nativeBuildInputs or [ ]);

    # protobuf is freezed to 3.6 because of this bug: https://github.com/mumble-voip/mumble/issues/3617
    # this could be reverted to the latest version in a future release of mumble as it is already fixed in master
    buildInputs = [ boost protobuf3_6 avahi ]
      ++ optional (source.qtVersion == 4) qt4
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
      ++ (overrides.configureFlags or [ ]);

    preConfigure = ''
       qmakeFlags="$qmakeFlags DEFINES+=PLUGIN_PATH=$out/lib/mumble"
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
      homepage = https://mumble.info;
      license = licenses.bsd3;
      maintainers = with maintainers; [ ];
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

  server = source: let ice = if source.qtVersion == 4 then zeroc-ice-36 else zeroc-ice; in generic {
    type = "murmur";

    postPatch = optional iceSupport ''
      grep -Rl '/usr/share/Ice' . | xargs sed -i 's,/usr/share/Ice/,${ice.dev}/share/ice/,g'
    '';

    configureFlags = [
      "CONFIG+=no-client"
    ] ++ optional (!iceSupport) "CONFIG+=no-ice";

    buildInputs = [ libcap ] ++ optional iceSupport ice;

    installPhase = ''
      # bin stuff
      install -Dm755 release/murmurd $out/bin/murmurd
    '';
  } source;

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

  rcSource = rec {
    version = "1.3.0-rc2";
    qtVersion = 5;

    # Needs submodules
    src = fetchFromGitHub {
      owner = "mumble-voip";
      repo = "mumble";
      rev = version;
      sha256 = "00irlzz5q4drmsfbwrkyy7p7w8a5fc1ip5vyicq3g3cy58dprpqr";
      fetchSubmodules = true;
    };
  };
in {
  mumble     = client stableSource;
  mumble_rc  = client rcSource;
  murmur     = server stableSource;
  murmur_rc  = server rcSource;
}
