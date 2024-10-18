{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  premake5,
  writeShellScriptBin,
  runCommandLocal,
  symlinkJoin,
  imagemagick,
  bzip2,
  curl,
  flac,
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
  deps = import ./deps.nix;
in
let
  assets = {
    pname = "assets";
    version = deps.edopro-version;

    src = fetchzip {
      url = "https://github.com/ProjectIgnis/edopro-assets/releases/download/${deps.edopro-version}/ProjectIgnis-EDOPro-${deps.edopro-version}-linux.tar.gz";
      sha256 = deps.assets-hash;
    };
  };

  irrlicht-edopro = stdenv.mkDerivation {
    pname = "irrlicht-edopro";
    version = "1.9-custom";

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
    buildFlags = "NDEBUG=1";
    makeFlags = "-C source/Irrlicht";

    installPhase = ''
      mkdir -p $out/{bin,include}
      cp lib/Linux/libIrrlicht.a $out/bin
      cp -r include/* $out/include
    '';
  };

  ocgcore = stdenv.mkDerivation rec {
    pname = "ygopro-core";
    version = deps.ocgcore-rev;

    src = fetchFromGitHub {
      owner = "edo9300";
      repo = pname;
      rev = version;
      hash = deps.ocgcore-hash;
      fetchSubmodules = true;
    };

    nativeBuildInputs = [ premake5 ];

    buildInputs = [ lua5_3 ];

    preBuild = ''
      premake5 gmake2
    '';

    enableParallelBuilding = true;
    buildFlags = "verbose=true config=release ocgcore";
    makeFlags = "-C build";

    installPhase = ''
      mkdir -p $out/bin
      cp bin/release/libocgcore.a $out/bin
    '';
  };

  edopro = stdenv.mkDerivation rec {
    pname = "edopro";
    version = deps.edopro-version;

    src = fetchFromGitHub {
      owner = "edo9300";
      repo = pname;
      rev = deps.edopro-rev;
      hash = deps.edopro-hash;
      fetchSubmodules = true;
    };

    nativeBuildInputs = [ premake5 ];

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
      nlohmann_json
      openal
      SDL2
      sqlite
    ];

    # nixpkgs' gcc stack currently appears to not support LTO
    postPatch = ''
      sed -i '/LinkTimeOptimization/d' ./premake5.lua
    '';

    preBuild = ''
      premake5 gmake2 \
        --covers=\"${covers_url}\" \
        --fields=\"${fields_url}\" \
        --no-core \
        --pics=\"${pics_url}\" \
        --prebuilt-core="${ocgcore}/bin" \
        --sound=sfml
    '';

    enableParallelBuilding = true;
    CXXFLAGS = "-include cstdint";
    LDFLAGS = "-I ${irrlicht-edopro}/include -L ${irrlicht-edopro}/bin";
    buildFlags = "verbose=true config=release_x64 ygoprodll";
    makeFlags = "-C build";

    installPhase = ''
      mkdir -p $out/bin
      cp bin/x64/release/ygoprodll $out/bin
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
    writeShellScriptBin "EDOPro" ''
      set -eu
      EDOPRO_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/edopro"

      if [ ! -d $EDOPRO_DIR ]; then
          mkdir -p $EDOPRO_DIR
          cp -r ${assets.src}/{${assetsToCopy}} $EDOPRO_DIR

          find $EDOPRO_DIR -type d -exec chmod u=rwx,go-rwx {} +
          find $EDOPRO_DIR -type f -exec chmod u=rw,go-rwx {} +

          rm $EDOPRO_DIR/config/io.github.edo9300.EDOPro.desktop.in
      fi

      export PATH=PATH:'${lib.makeBinPath [ mono ]}';
      export LD_LIBRARY_PATH='${
        lib.makeLibraryPath [
          libGL
          libX11
          libxkbcommon
          libXxf86vm
          sqlite
          wayland
          egl-wayland
        ]
      }';

      exec ${edopro}/bin/ygoprodll -C $EDOPRO_DIR $@
    '';

  edopro-desktop = runCommandLocal "io.github.edo9300.EDOPro.desktop" { } ''
    cp ${assets.src}/config/io.github.edo9300.EDOPro.desktop.in desktop-template

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
    edopro
    edopro-script
    edopro-desktop
  ];

  postBuild = ''
    mkdir -p $out/share/icons/hicolor/256x256/apps/
    ${imagemagick}/bin/magick \
        ${assets.src}/textures/AppIcon.png \
        -resize 256x256 \
        $out/share/icons/hicolor/256x256/apps/EDOPro.png
  '';

  passthru.updateScript = ./update.py;

  meta = with lib; {
    description = "The bleeding-edge automatic duel simulator, a fork of the YGOPro client.";
    homepage = "https://projectignis.github.io";
    changelog = "https://github.com/edo9300/edopro/releases";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      redhawk
      tlater
    ];
    mainprogram = "edopro";
    # This is likely a very easy app to port if you're interested.
    # We just have no way to test on other platforms.
    platforms = [ "x86_64-linux" ];
  };
}
