{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  makeWrapper,
  premake5,
  writeShellScriptBin,
  runCommandLocal,
  symlinkJoin,
  imagemagick,
  bzip2,
  curl,
  flac,
  # Use fmt 10+ after release 40.1.4+
  fmt_9,
  freetype,
  libevent,
  libgit2,
  libGL,
  libGLU,
  libjpeg,
  libpng,
  libvorbis,
  libX11,
  libxkbcommon,
  libXxf86vm,
  lua5_3,
  mono,
  nlohmann_json,
  openal,
  SDL2,
  sqlite,
  wayland,
  egl-wayland,
  covers_url ? "https://pics.projectignis.org:2096/pics/cover/{}.jpg",
  fields_url ? "https://pics.projectignis.org:2096/pics/field/{}.png",
  # While ygoprodeck has higher quality images, "spamming" of their api results in a ban.
  # Thats why this link can change since it's compiled into the program, However it will
  # download assets when needed so it is unlikely to get banned. Unless you search the
  # card list with no filters of any kind. When testing use ProjectIgnis' website instead.
  pics_url ? "https://images.ygoprodeck.com/images/cards/{}.jpg",
}:
let
  archLabel =
    {
      "x86_64-linux" = "x64";
      "aarch64-linux" = "arm64";
    }
    .${stdenv.hostPlatform.system}
      or (throw "${stdenv.hostPlatform.system} is an unsupported arch label for edopro");

  deps = import ./deps.nix;
in
let
  assets = fetchzip {
    url = "https://github.com/ProjectIgnis/edopro-assets/releases/download/${deps.edopro-version}/ProjectIgnis-EDOPro-${deps.edopro-version}-linux.tar.gz";
    hash = deps.assets-hash;
  };

  irrlicht-edopro = stdenv.mkDerivation {
    pname = "irrlicht-edopro";
    version = deps.irrlicht-version;

    src = fetchFromGitHub {
      owner = "edo9300";
      repo = "irrlicht1-8-4";
      rev = deps.irrlicht-rev;
      hash = deps.irrlicht-hash;
    };

    buildInputs = [
      libGLU
      libX11
      libxkbcommon
      libXxf86vm
      wayland
    ];

    enableParallelBuilding = true;
    buildFlags = [
      "NDEBUG=1"
    ];
    makeFlags = [
      "-C"
      "source/Irrlicht"
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,include}
      cp lib/Linux/libIrrlicht.a $out/bin
      cp -r include/* $out/include

      runHook postInstall
    '';
  };

  ocgcore = stdenv.mkDerivation {
    pname = "ygopro-core";
    version = deps.ocgcore-version;

    src = fetchFromGitHub {
      owner = "edo9300";
      repo = "ygopro-core";
      rev = deps.ocgcore-rev;
      hash = deps.ocgcore-hash;
      fetchSubmodules = true;
    };

    patches = [
      ./ocgcore-lua-symbols.patch
    ];

    nativeBuildInputs = [ premake5 ];

    buildInputs = [ lua5_3 ];

    preBuild = ''
      premake5 gmake2 \
        --lua-path="${lua5_3}"
    '';

    enableParallelBuilding = true;
    buildFlags = [
      "verbose=true"
      "config=release"
      "ocgcoreshared"
    ];
    makeFlags = [
      "-C"
      "build"
    ];

    installPhase = ''
      runHook preInstall

      install -Dm644 -t $out/lib bin/release/libocgcore${stdenv.hostPlatform.extensions.sharedLibrary}

      runHook postInstall
    '';
  };

  edopro = stdenv.mkDerivation {
    pname = "edopro";
    version = deps.edopro-version;

    src = fetchFromGitHub {
      owner = "edo9300";
      repo = "edopro";
      rev = deps.edopro-rev;
      hash = deps.edopro-hash;
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      makeWrapper
      premake5
    ];

    buildInputs = [
      bzip2
      curl
      flac
      fmt_9
      freetype
      irrlicht-edopro
      libevent
      libgit2
      libjpeg
      libpng
      libvorbis
      lua5_3
      nlohmann_json
      ocgcore
      openal
      SDL2
      sqlite
    ];

    # nixpkgs' gcc stack currently appears to not support LTO
    postPatch = ''
      substituteInPlace premake5.lua \
        --replace-fail 'flags "LinkTimeOptimization"' 'removeflags "LinkTimeOptimization"'
    '';

    preBuild = ''
      premake5 gmake2 \
        --architecture=${archLabel} \
        --covers=\"${covers_url}\" \
        --fields=\"${fields_url}\" \
        --pics=\"${pics_url}\" \
        --prebuilt-core="${lib.getLib ocgcore}/lib" \
        --sound=sfml
    '';

    enableParallelBuilding = true;
    env = {
      # remove after release 40.1.4+
      # https://discord.com/channels/170601678658076672/792223685112889344/1286043823293599785
      CXXFLAGS = "-include cstdint";
      LDFLAGS = "-I ${irrlicht-edopro}/include -L ${irrlicht-edopro}/bin";
    };
    buildFlags = [
      "verbose=true"
      "config=release_${archLabel}"
      "ygopro"
    ];
    makeFlags = [
      "-C"
      "build"
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp bin/${archLabel}/release/ygopro $out/bin
      wrapProgram $out/bin/ygopro \
        --prefix PATH : ${lib.makeBinPath [ mono ]} \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            libGL
            libX11
            libxkbcommon
            libXxf86vm
            sqlite
            wayland
            egl-wayland
          ]
        }

      runHook postInstall
    '';
  };

  edopro-script =
    let
      assetsToCopy = lib.concatStringsSep "," [
        # Needed if we download files from ProjectIgnis' website or any https only website.
        "cacert.pem"
        "config"
        "deck"
        "COPYING.txt"
        "expansions"
        "lflists"
        "notices"
        "puzzles"
        "fonts"
        "script"
        "skin"
        "sound"
        "textures"
        "WindBot"
      ];
    in
    writeShellScriptBin "edopro" ''
      set -eu
      EDOPRO_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/edopro"

      if [ ! -d $EDOPRO_DIR ]; then
          mkdir -p $EDOPRO_DIR
          cp -r --no-preserve=all ${assets}/{${assetsToCopy}} $EDOPRO_DIR
          chmod -R go-rwx $EDOPRO_DIR

          rm $EDOPRO_DIR/config/io.github.edo9300.EDOPro.desktop.in
      fi

      exec ${edopro}/bin/ygopro -C $EDOPRO_DIR $@
    '';

  edopro-desktop = runCommandLocal "io.github.edo9300.EDOPro.desktop" { } ''
    cp ${assets}/config/io.github.edo9300.EDOPro.desktop.in desktop-template

    sed '/Path=/d' -i desktop-template
    sed 's/Exec=.*/Exec=EDOPro/' -i desktop-template
    sed 's/Icon=.*/Icon=EDOPro/' -i desktop-template

    install -D desktop-template $out/share/applications/io.github.edo9300.EDOPro.desktop
  '';
in
symlinkJoin {
  name = "edopro-application-${deps.edopro-version}";
  version = deps.edopro-version;
  paths = [
    edopro-script
    edopro-desktop
  ];

  postBuild = ''
    mkdir -p $out/share/icons/hicolor/256x256/apps/
    ${imagemagick}/bin/magick \
        ${assets}/textures/AppIcon.png \
        -resize 256x256 \
        $out/share/icons/hicolor/256x256/apps/EDOPro.png
  '';

  passthru.updateScript = ./update.py;

  meta = {
    description = "Bleeding-edge automatic duel simulator, a fork of the YGOPro client";
    homepage = "https://projectignis.github.io";
    changelog = "https://github.com/edo9300/edopro/releases";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      OPNA2608
      redhawk
    ];
    mainProgram = "edopro";
    # This is likely a very easy app to port if you're interested.
    # We just have no way to test on other platforms.
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
