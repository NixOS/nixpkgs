{
  stdenv,
  lib,
  fetchFromGitHub,
  copyDesktopItems,
  haxe,
  haxePackages,
  neko,
  makeWrapper,
  imagemagick,
  alsa-lib,
  libpulseaudio,
  libGL,
  libX11,
  libXdmcp,
  libXext,
  libXi,
  libXinerama,
  libXrandr,
  makeDesktopItem,
}:

let
  flxanimate = haxePackages.flxanimate.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "FunkinCrew";
      repo = "flxanimate";
      rev = "17e0d59fdbc2b6283a5c0e4df41f1c7f27b71c49";
      sha256 = "sha256-4vRzBMjY5rXcVfqkgRxkYG6dtgVPaddvOlTuO0zLO8A=";
    };
    sha256 = null;
  });

  json2object = haxePackages.json2object.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "FunkinCrew";
      repo = "json2object";
      rev = "a8c26f18463c98da32f744c214fe02273e1823fa";
      sha256 = "sha256-oCryNSdFAXnlhEschnk2XYd8MdPxndXx5O6sX5ncuik=";
    };
    sha256 = null;
  });

  flixel = haxePackages.flixel.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "FunkinCrew";
      repo = "flixel";
      rev = "a7d8e3bad89a0a3506a4714121f73d8e34522c49";
      sha256 = "sha256-8whUD7LftJuWPBo0UDgNnBZ5FFmo4TD0I6bO3NrXBJU=";
    };
    sha256 = null;
  });

  flixel-addons = haxePackages.flixel-addons.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "FunkinCrew";
      repo = "flixel-addons";
      rev = "a523c3b56622f0640933944171efed46929e360e";
      sha256 = "sha256-KkR6an72UJkAMD3E9AMShA8Klf06K1EWyQXMH4t7s2Q=";
    };
    sha256 = null;
  });

  flixel-ui = haxePackages.flixel-ui.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "HaxeFlixel";
      repo = "flixel-ui";
      rev = "719b4f10d94186ed55f6fef1b6618d32abec8c15";
      sha256 = "sha256-avHZGjZ6sxaiDrKUafd3K7qcj7AZ1QP1UAkAQKDhnZA=";
    };
    sha256 = null;
  });

  openfl = haxePackages.openfl.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "FunkinCrew";
      repo = "openfl";
      rev = "228c1b5063911e2ad75cef6e3168ef0a4b9f9134";
      sha256 = "sha256-fZHcNZ7yR4+BKCPda7s3fiS68DRakYVMiljrQZ0+69s=";
    };
    sha256 = null;
  });

  lime = haxePackages.lime.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "FunkinCrew";
      repo = "lime";
      rev = "872ff6db2f2d27c0243d4ff76802121ded550dd7";
      sha256 = "sha256-tFOwdJUJf+wSULDnXK1ePJh1DR+pj+rxHt2gznolRt8=";
    };
    sha256 = null;
  });

  thx_core = haxePackages.thx_core.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "fponticelli";
      repo = "thx.core";
      rev = "76d87418fadd92eb8e1b61f004cff27d656e53dd";
      sha256 = "sha256-7B45I/h2FommdaRGrolEyMcoea+k7WlqYyPzZ10Bg/c=";
    };
    sha256 = null;
  });

  thx_semver = haxePackages.thx_semver.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "FunkinCrew";
      repo = "thx.semver";
      rev = "cf8d213589a2c7ce4a59b0fdba9e8ff36bc029fa";
      sha256 = "sha256-eTldd/SG8xXRwiL1fcO6JYQD6EI9AgsmUlTpdwFLvQo=";
    };
    sha256 = null;
  });

  hxcodec = haxePackages.hxcodec.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "FunkinCrew";
      repo = "hxCodec";
      rev = "61b98a7a353b7f529a8fec84ed9afc919a2dffdd";
      sha256 = "sha256-NXh1CoNmWcCUbWme5IsGpfd/JL2A6bbSzhrgW+is2Tc=";
    };
    sha256 = null;
  });

  jsonpatch = haxePackages.jsonpatch.overrideAttrs (old: {
    propagatedBuildInputs =
      builtins.filter (x: x.pname != "thx.core") (old.propagatedBuildInputs or [ ])
      ++ [ thx_core ];
  });

  polymod = haxePackages.polymod.overrideAttrs (old: {
    propagatedBuildInputs =
      builtins.filter (x: x.pname != "jsonpatch") (old.propagatedBuildInputs or [ ])
      ++ [ jsonpatch ];
  });
in
stdenv.mkDerivation rec {
  pname = "funkin";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "FunkinCrew";
    repo = "Funkin";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-5VvxsEL9TA7sYdX2jJB22r+tZiwdf9FoaTxE4Q59UAY=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "funkin";
      exec = "Funkin";
      desktopName = "Friday Night Funkin";
      categories = [
        "Game"
        "ArcadeGame"
      ];
      icon = "funkin";
    })
  ];

  postPatch = ''
    # Real API keys are stripped from repo
    cat >source/APIStuff.hx <<EOF
    package;

    class APIStuff
    {
      public static var API:String = "";
      public static var EncKey:String = "";
    }
    EOF
  '';

  nativeBuildInputs =
    [
      haxe
      neko
      makeWrapper
      imagemagick
      copyDesktopItems
    ]
    ++ (with haxePackages; [
      # Here, in the same order as in the Project.xml file
      hxcpp

      lime
      openfl
      flixel

      flixel-addons
      hscript
      flixel-ui
      haxeui-core
      haxeui-flixel
      flixel-text-input
      polymod
      flxanimate
      hxcodec
      funkin.vis
      grig.audio

      format
      hxp
      FlxPartialSound
      thx_core
      thx_semver
      json2object
    ]);

  buildInputs = [
    alsa-lib
    libpulseaudio
    libGL
    libX11
    libXdmcp
    libXext
    libXi
    libXinerama
    libXrandr
  ];

  enableParallelBuilding = true;

  prePatch = ''
    substituteInPlace source/funkin/util/Constants.hx \
      --replace "funkin.util.macro.GitCommit.getGitCommitHash();" "\"unspecified-nix\";" \
      --replace "funkin.util.macro.GitCommit.getGitBranch()" "\"main\""
  '';

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    haxelib run lime build linux -final

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/funkin}
    cp -R export/release/linux/bin/* $out/lib/funkin/
    wrapProgram $out/lib/funkin/Funkin \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
      --run "cd $out/lib/funkin"
    ln -s $out/{lib/funkin,bin}/Funkin

    # icons
    for i in 16 32 64; do
      install -D art/icon$i.png $out/share/icons/hicolor/''${i}x$i/funkin.png
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Friday Night Funkin'";
    longDescription = ''
      Uh oh! Your tryin to kiss ur hot girlfriend, but her MEAN and EVIL dad is
      trying to KILL you! He's an ex-rockstar, the only way to get to his
      heart? The power of music...

      WASD/ARROW KEYS IS CONTROLS

      - and + are volume control

      0 to Mute

      It's basically like DDR, press arrow when arrow over other arrow.
      And uhhh don't die.
    '';
    homepage = "https://ninja-muffin24.itch.io/funkin";
    # code is asl20, but most assets are unfree
    license = [
      licenses.asl20
      licenses.unfree
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ marius851000 ];
  };
}
