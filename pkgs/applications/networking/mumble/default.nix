{ stdenv, fetchurl, fetchgit, pkgconfig
, qt4, qt5, avahi, boost, libopus, libsndfile, protobuf, speex, libcap
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
      ++ { qt4 = [ qt4 ]; qt5 = [ qt5.qtbase ]; }."qt${toString source.qtVersion}"
      ++ (overrides.nativeBuildInputs or [ ]);
    buildInputs = [ boost protobuf avahi ]
      ++ { qt4 = [ qt4 ]; qt5 = [ qt5.qtbase ]; }."qt${toString source.qtVersion}"
      ++ (overrides.buildInputs or [ ]);

    configureFlags = [
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

    configurePhase = ''
      runHook preConfigure
      qmake $configureFlags DEFINES+="PLUGIN_PATH=$out/lib"
      runHook postConfigure
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

    installPhase = ''
      cp scripts/mumble-overlay $out/bin
      sed -i "s,/usr/lib,$out/lib,g" $out/bin/mumble-overlay

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
    version = "1.2.10";
    qtVersion = 4;

    src = fetchurl {
      url = "https://github.com/mumble-voip/mumble/releases/download/${version}/mumble-${version}.tar.gz";
      sha256 = "012vm0xf84x13414jlsx964c5a1nwnbn41jnspkciajlxxipldn6";
    };
  };

  gitSource = rec {
    version = "1.3.0-git-2015-11-08";
    qtVersion = 5;

    src = fetchgit {
      url = "https://github.com/mumble-voip/mumble";
      rev = "72038f6aa038f5964e2bba5a09d3d391d4680e5f";
      sha256 = "03978b85f7y0bffl8vwkmakjnxxjqapfz3pn0b8zf3b1ppwjy9g4";
    };

    # TODO: Remove fetchgit as it requires git
    /*src = fetchFromGitHub {
      owner = "mumble-voip";
      repo = "mumble";
      rev = "13e494c60beb20748eeb8be126b27e1226d168c8";
      sha256 = "024my6wzahq16w7fjwrbksgnq98z4jjbdyy615kfyd9yk2qnpl80";
    };

    theme = fetchFromGitHub {
      owner = "mumble-voip";
      repo = "mumble-theme";
      rev = "16b61d958f131ca85ab0f601d7331601b63d8f30";
      sha256 = "0rbh825mwlh38j6nv2sran2clkiwvzj430mhvkdvzli9ysjxgsl3";
    };

    prePatch = ''
      rmdir themes/Mumble
      ln -s ${theme} themes/Mumble
    '';*/
  };
in {
  mumble     = client stableSource;
  mumble_git = client gitSource;
  murmur     = server stableSource;
  murmur_git = server gitSource;
}
