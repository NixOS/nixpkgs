{ stdenv
, gogextract
, unzip
, makeWrapper
, autoPatchelfHook
, imagemagick
, makeDesktopItem
}:

{ pname
, displayName ? pname
, nativeBuildInputs ? [ ]
, unpackPhase ? ""
, installPhase ? ""
, ...
}@attrs:
stdenv.mkDerivation (attrs // {
  nativeBuildInputs = nativeBuildInputs ++ [
    gogextract
    unzip
    makeWrapper
    autoPatchelfHook
    imagemagick
  ];

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    desktopName = displayName;
    categories = "Game;";
  };

  unpackPhase = ''
    gogextract $src .
    unzip data.zip
    ${unpackPhase}
  '';

  # This was written for Stellaris, and might need tweaking to work with other games.
  installPhase = ''
    mkdir -p $out
    echo '  copying files'
    cp -R data/noarch $out/data
    echo '  installing executables'
    makeWrapper $out/data/game/$pname $out/bin/$pname
    install -Dm644 -t $out/share/applications $desktopItem/share/applications/*

    echo '  installing icons'
    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps
      convert data/noarch/support/icon.png \
        -resize $size \
        $out/share/icons/hicolor/$size/apps/$pname.png
    done
    ${installPhase}
  '';
})
