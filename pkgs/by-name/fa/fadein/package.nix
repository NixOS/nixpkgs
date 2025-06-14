{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  cairo,
  fontconfig,
  gdk-pixbuf,
  glib,
  gtk3,
  libuuid,
  pango,
  zlib,
  libsm,
  libx11,
  libxxf86vm,
  curl,
  webkitgtk_4_1,
  libjpeg8,
}:

stdenv.mkDerivation {
  pname = "fadein";
  version = "5.0.2";

  src = fetchzip {
    url = "https://web.archive.org/web/20251101223813/https://www.fadeinpro.com/download/demo/fadein-linux-x64-demo.tar.gz";
    hash = "sha256-m2zscwE0ZUnxalhz2lclurtyTzPmGATHzlNtMBeyHos=";
  };

  strictDeps = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    cairo
    fontconfig
    gdk-pixbuf
    glib
    gtk3
    libuuid
    pango
    (lib.getLib stdenv.cc.cc)
    libsm
    libx11
    libxxf86vm
    curl
    libjpeg8
    webkitgtk_4_1
    zlib
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share
    cp -r usr/share/* $out/share

    # Fix icon
    install -m 444 -D usr/share/fadein/icon_app/fadein_icon_256x256.png $out/share/icons/hicolor/256x256/apps/fadein.png
    substituteInPlace $out/share/applications/fadein.desktop \
      --replace-fail 'Icon=/usr/share/fadein/icon_app/fadein_icon_256x256.png' 'Icon=fadein'

    mkdir -p $out/bin
    ln -s "$out/share/fadein/fadein" "$out/bin/fadein"
    runHook postInstall
  '';

  meta = {
    description = "Writing motion picture screenplays.";
    homepage = "https://www.fadeinpro.com/";
    license = lib.licenses.unfree;
    mainProgram = "fadein";
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = [ "x86_64-linux" ];
  };
}
