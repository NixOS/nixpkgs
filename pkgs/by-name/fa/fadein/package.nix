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
  version = "5.0.5";

  src = fetchzip {
    url = "https://web.archive.org/web/20251115223750/https://www.fadeinpro.com/download/demo/fadein-linux-x64-demo.tar.gz";
    hash = "sha256-3UByoUbrH0Y/1+J9yovwI3FUI0n4HYbVAD/8wKNdCWE=";
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

    # Fix icons
    for size in 16 24 32 48 64 96 128 256 512; do
      install -m 444 -D \
        "usr/share/fadein/icon_app/fadein_icon_''${size}x''${size}.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/fadein.png"

      install -m 444 -D \
        "usr/share/fadein/icon_app/fadein_doc_''${size}x''${size}.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/mimetypes/application-x-fadein-document.png"
    done

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
