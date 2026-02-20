{
  lib,
  fetchFromGitHub,
  stdenv,
  callPackage,
  cmake,
  boost,
  SDL2,
  libvorbis,
  pkg-config,
  makeWrapper,
  enet,
  bullet,
  openal,
  tinyxml-2,
  rapidjson,
  ogre-next,
  ninja,
  libx11,
}:

let
  mygui = callPackage ./mygui.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "stuntrally";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "stuntrally";
    repo = "stuntrally3";
    tag = finalAttrs.version;
    hash = "sha256-BJMMsJ/ONZTpvXetaaHlgm6rih9oZmtJNBXv0IM855Y=";
  };

  tracks = fetchFromGitHub {
    owner = "stuntrally";
    repo = "tracks3";
    tag = finalAttrs.version;
    hash = "sha256-nvIN5hIfTfnuJdlLNlmpmYo3WQhUxYWz14OFra/55w4=";
  };

  patches = [
    ./stuntrally-use-pkg-config-for-ogre-next.patch
    ./stuntrally-init-data-dirs-to-nix-paths.patch
  ];

  postPatch = ''
    substituteInPlace bin/Release/plugins.cfg \
      --replace-fail "PluginFolder=." "PluginFolder=${ogre-next}/lib/OGRE/"
    substituteInPlace src/vdrift/paths.cpp \
      --replace-fail "@GAME_DATA_DIR@" "$out/share/stuntrally3/data" \
      --replace-fail "@GAME_CONFIG_DIR@" "$out/share/stuntrally3/config"
  '';

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
    makeWrapper
  ];

  buildInputs = [
    boost
    ogre-next
    mygui
    rapidjson
    SDL2
    libvorbis
    enet
    bullet
    openal
    tinyxml-2
    libx11
  ];

  installPhase = ''
    runHook preInstall

    pushd ..

    share_dir=$out/share/stuntrally3
    mkdir -p $share_dir
    cp -r config $share_dir/config
    cp bin/Release/plugins.cfg $share_dir/config
    cp -r data $share_dir/data
    cp -r ${finalAttrs.tracks} $share_dir/data/tracks

    install -Dm644 -t $out/share/icons/hicolor/512x512/apps data/gui/{stuntrally,sr-editor}.png
    install -Dm644 -t $out/share/applications dist/{stuntrally3,sr-editor3}.desktop

    for binary in sr-editor3 sr-translator stuntrally3
    do
      install -Dm755 -t $out/bin bin/Release/$binary
      # Force X11, otherwise fails with `OGRE EXCEPTION(9:UnimplementedException)`
      wrapProgram $out/bin/$binary \
        --set SDL_VIDEODRIVER x11
    done

    popd

    runHook postInstall
  '';

  passthru = {
    inherit mygui;
  };

  meta = {
    description = "3D racing game with Sci-Fi elements and own Track Editor";
    homepage = "https://cryham.org/stuntrally/";
    mainProgram = "stuntrally3";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.linux;
  };
})
