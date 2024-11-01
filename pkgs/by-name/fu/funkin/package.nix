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
  overrideHaxeLibFromHMM,
}:

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

  patches = [ ./write-in-app-storage.diff ];

  postPatch = ''
    substituteInPlace source/funkin/util/Constants.hx \
      --replace "funkin.util.macro.GitCommit.getGitCommitHash();" "\"unspecified-nix\";" \
      --replace "funkin.util.macro.GitCommit.getGitBranch()" "\"main\""

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
    ++ (overrideHaxeLibFromHMM {
      hmm = lib.importJSON ./hmm.json;
      hashes = lib.importJSON ./hashes.json;
      packages = (
        with haxePackages;
        [
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
        ]
      );
    });

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
