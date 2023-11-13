{ stdenv
, meta
, lib
, fetchurl
, mpv
, graphicsmagick
, electron_24
, makeDesktopItem
, makeWrapper
, pname
, appname
, version
}:

let
  icon = fetchurl {
    url =
      "https://github.com/jeffvli/feishin/raw/development/assets/icons/1024x1024.png";
    sha256 = "sha256-8Qigt1CNMa3SDVK2cdqWJuMSl19yfy6nPQfME4qA48I=";
  };

  desktopItem = makeDesktopItem {
    name = "feishin";
    desktopName = "Feishin";
    comment = "Full-featured Subsonic/Jellyfin compatible desktop music player";
    icon = "feishin";
    exec = "feishin %u";
    categories = [ "Audio" ];
    mimeTypes = [ "x-scheme-handler/feishin" ];
  };
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/jeffvli/feishin/releases/download/v${version}/${appname}-${version}-linux-x64.tar.xz";
    hash = "sha256-sl2zM24bb0yBTfCxtNGizp6Yu+L4nj/Uf669zylnPmE=";
  };


  nativeBuildInputs = [ makeWrapper graphicsmagick ];

  # Installs mpv as a requirement
  propagatedBuildInputs = [ mpv ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share
    cp -r resources $out/share/${pname}/
    cp -r locales $out/share/${pname}/

    makeWrapper ${electron_24}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/app.asar
    install -m 444 -D "${desktopItem}/share/applications/"* \
      -t $out/share/applications/
    for size in 16 24 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      gm convert -resize "$size"x"$size" ${icon} $out/share/icons/hicolor/"$size"x"$size"/apps/${appname}.png
    done
    runHook postInstall
  '';

  shellHook = ''
    set -x
    export LD_LIBRARY_PATH=${mpv}/lib
    set +x
  '';
}
