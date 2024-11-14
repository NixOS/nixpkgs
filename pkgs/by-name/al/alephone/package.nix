{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  alsa-lib,
  boost,
  curl,
  ffmpeg_6,
  icoutils,
  libGLU,
  libmad,
  libogg,
  libpng,
  libsndfile,
  libvorbis,
  lua,
  makeDesktopItem,
  makeWrapper,
  miniupnpc,
  openal,
  pkg-config,
  SDL2,
  SDL2_image,
  SDL2_net,
  SDL2_ttf,
  speex,
  unzip,
  zlib,
  zziplib,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  outputs = [
    "out"
    "icons"
  ];
  pname = "alephone";
  version = "1.10";

  src = fetchurl {
    url =
      let
        date = "20240822";
      in
      "https://github.com/Aleph-One-Marathon/alephone/releases/download/release-${date}/AlephOne-${date}.tar.bz2";
    hash = "sha256-Es2Uo0RIJHYeO/60XiHVLJe9Eoan8DREtAI2KGjuLaM=";
  };

  nativeBuildInputs = [
    pkg-config
    icoutils
  ];

  buildInputs = [
    alsa-lib
    boost
    curl
    ffmpeg_6
    libGLU
    libmad
    libogg
    libpng
    libsndfile
    libvorbis
    lua
    miniupnpc
    openal
    SDL2
    SDL2_image
    SDL2_net
    SDL2_ttf
    speex
    zlib
    zziplib
  ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ];
  makeFlags = [ "AR:=$(AR)" ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir $icons
    icotool -x -i 5 -o $icons Resources/Windows/*.ico
    pushd $icons
    for x in *_5_48x48x32.png; do
      mv $x ''${x%_5_48x48x32.png}.png
    done
    popd
  '';

  passthru.tests.version =
    # test that the version is correct
    testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    description = "Aleph One is the open source continuation of Bungie’s Marathon 2 game engine";
    mainProgram = "alephone";
    homepage = "https://alephone.lhowon.org/";
    license = [ lib.licenses.gpl3 ];
    maintainers = with lib.maintainers; [ ehmry ];
    platforms = lib.platforms.linux;
  };

  passthru.makeWrapper =
    {
      pname,
      desktopName,
      version,
      zip,
      meta,
      icon ? finalAttrs.finalPackage.icons + "/alephone.png",
      ...
    }@extraArgs:
    stdenv.mkDerivation (
      {
        inherit pname version;

        desktopItem = makeDesktopItem {
          name = desktopName;
          exec = pname;
          genericName = pname;
          categories = [ "Game" ];
          comment = meta.description;
          inherit desktopName icon;
        };

        src = zip;

        nativeBuildInputs = [
          makeWrapper
          unzip
        ];

        dontConfigure = true;
        dontBuild = true;

        installPhase = ''
          mkdir -p $out/bin $out/data/$pname $out/share/applications
          cp -a * $out/data/$pname
          cp $desktopItem/share/applications/* $out/share/applications
          makeWrapper ${finalAttrs.finalPackage}/bin/alephone $out/bin/$pname \
            --add-flags $out/data/$pname
        '';
      }
      // extraArgs
      // {
        meta =
          finalAttrs.finalPackage.meta
          // {
            license = lib.licenses.free;
            mainProgram = pname;
            hydraPlatforms = [ ];
          }
          // meta;
      }
    );
})
