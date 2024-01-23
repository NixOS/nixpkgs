{ fetchurl
, stdenv
, lib
, atk
, cairo
, ffmpeg_4
, fontconfig
, gdk-pixbuf
, glib
, gtk3
, harfbuzz
, jsoncpp
, libappindicator-gtk3
, libass
, libdbusmenu-gtk3
, libepoxy
, libnotify
, libsecret
, mpv
, pango
, makeWrapper
, patchelf
, wrapGAppsHook
}:
let
  version = "3.4.0";

  src = fetchurl {
    url = "https://github.com/KRTirtho/spotube/releases/download/v${version}/spotube-linux-${version}-x86_64.tar.xz";
    name = "spotube-linux-${version}-x86_64.tar.xz";
    sha256 = "sha256-vTK3aWM1Aly3yCNEpQS0y+4dHTjsn2VWJAI9Sk518rg=";
  };

  buildInputs = [
    atk
    cairo
    ffmpeg_4
    fontconfig
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    jsoncpp
    libappindicator-gtk3
    libass
    libdbusmenu-gtk3
    libepoxy
    libnotify
    libsecret
    mpv
    pango
  ];
in
stdenv.mkDerivation {
  pname = "spotube";
  inherit version src buildInputs;

  nativeBuildInputs = [
    makeWrapper
    patchelf
    stdenv.cc.cc.lib
    wrapGAppsHook
  ];

  unpackPhase = ''
    mkdir -p $out/dist
    tar -C $out/dist -xf $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/spotube/

    install -Dm644 $out/dist/spotube.desktop $out/share/applications/
    install -Dm644 $out/dist/spotube-logo.png $out/share/icons/spotube/spotube-logo.png

    substituteInPlace $out/share/applications/spotube.desktop \
      --replace "Exec=/usr/bin/spotube" "Exec=$out/bin/spotube" \
      --replace "Icon=/usr/share/icons/spotube/spotube-logo.png" "Icon=$out/share/icons/spotube/spotube-logo.png"
  '';

  postFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${lib.makeLibraryPath [ stdenv.cc.cc ]} \
      $out/dist/spotube
    makeWrapper $out/dist/spotube $out/bin/spotube \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath buildInputs} \
      --suffix LD_LIBRARY_PATH : $out/dist/lib
  '';

  doCheck = false;
  dontBuild = true;

  meta = with lib; {
    description = "An open source, cross-platform Spotify client.";
    longDescription = ''
      An open source, cross-platform Spotify client compatible across multiple platforms
      utilizing Spotify's data API and YouTube (or Piped.video or JioSaavn) as an audio source,
      eliminating the need for Spotify Premium

      Btw it's not another Electron app.
    '';
    homepage = "https://github.com/KRTirtho/spotube";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.massimogengarelli ];
    platforms = platforms.linux;
  };
}

