{ lib
, stdenv
, fetchurl
, alsa-lib
, boost
, curl
, ffmpeg_4
, icoutils
, libGLU
, libmad
, libogg
, libpng
, libsndfile
, libvorbis
, lua
, makeDesktopItem
, makeWrapper
, miniupnpc
, openal
, pkg-config
, SDL2
, SDL2_image
, SDL2_net
, SDL2_ttf
, speex
, unzip
, zlib
, zziplib
, alephone
}:

stdenv.mkDerivation (finalAttrs: {
  outputs = [ "out" "icons" ];
  pname = "alephone";
  version = "1.8";

  src = fetchurl {
    url =
      let date = "20240510";
      in "https://github.com/Aleph-One-Marathon/alephone/releases/download/release-${date}/AlephOne-${date}.tar.bz2";
    sha256 = "sha256-3+3lTAVOxTTs13uuVsmq4CKmdNkQv+lY7YV1HkIwvDs=";
  };

  nativeBuildInputs = [ pkg-config icoutils ];

  buildInputs = [
    alsa-lib
    boost
    curl
    ffmpeg_4
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

  meta = {
    description =
      "Aleph One is the open source continuation of Bungie’s Marathon 2 game engine";
    mainProgram = "alephone";
    homepage = "https://alephone.lhowon.org/";
    license = [ lib.licenses.gpl3 ];
    maintainers = with lib.maintainers; [ ehmry ];
    platforms = lib.platforms.linux;
  };

  passthru.makeWrapper =
    { pname
    , desktopName
    , version
    , zip
    , meta
    , icon ? alephone.icons + "/alephone.png"
    , ...
    }@extraArgs:
    stdenv.mkDerivation ({
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

      nativeBuildInputs = [ makeWrapper unzip ];

      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        mkdir -p $out/bin $out/data/$pname $out/share/applications
        cp -a * $out/data/$pname
        cp $desktopItem/share/applications/* $out/share/applications
        makeWrapper ${alephone}/bin/alephone $out/bin/$pname \
          --add-flags $out/data/$pname
      '';
    } // extraArgs // {
      meta = alephone.meta // {
        license = lib.licenses.free;
        mainProgram = pname;
        hydraPlatforms = [ ];
      } // meta;
    });
})
