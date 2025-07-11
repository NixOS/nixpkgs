{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  gtk3,
  cairo,
  pango,
  harfbuzz,
  atk,
  at-spi2-atk,
  gdk-pixbuf,
  glib,
  libsecret,
  mpv,
  libepoxy,
  curl,
  ayatana-ido,
  libayatana-common,
  libayatana-indicator,
  libayatana-appindicator,
  libdbusmenu-gtk3,
  fontconfig,
  wayland,
  flutter,
  sentry-native,
  libsodium,
  sqlite,
  patchelf,
}:

let
  libs = [
    stdenv.cc.cc
    flutter
    gtk3
    cairo
    pango
    harfbuzz
    atk
    at-spi2-atk
    gdk-pixbuf
    glib
    libepoxy
    curl
    libdbusmenu-gtk3
    fontconfig
    wayland
    mpv
    sentry-native
    libsodium
    sqlite
    libsecret
    ayatana-ido
    libayatana-common
    libayatana-indicator
    libayatana-appindicator
  ];

  libPath = lib.makeLibraryPath libs;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "s3drive";
  version = "1.11.2";

  src = fetchurl {
    url = "https://github.com/s3drive/deb-app/releases/download/${finalAttrs.version}/s3drive_amd64.deb";
    sha256 = "sZkpLAZLnkMTMV+7pbeuuUiIljUpxAXCZeBxg6KUGc4=";
  };

  nativeBuildInputs = [
    dpkg
    patchelf
  ];

  buildInputs = libs;

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/s3drive
    cp -r usr/local/lib/s3drive/* $out/lib/s3drive/
    chmod -R +w $out/lib/s3drive

    mkdir -p $out/bin
    ln -sf $out/lib/s3drive/kapsa $out/bin/s3drive

    mkdir -p $out/lib/s3drive/lib
    ln -sf ${mpv}/lib/libmpv.so $out/lib/s3drive/lib/libmpv.so.1

    rpath="${libPath}:$out/lib/s3drive/lib"

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             --set-rpath "$rpath" \
             $out/lib/s3drive/kapsa

    find $out/lib/s3drive/lib -name "*.so*" -type f -exec \
      patchelf --set-rpath "$rpath" {} \;


    mkdir -p $out/share/icons/
    cp usr/share/icons/kapsa.svg $out/share/icons/${finalAttrs.pname}.svg

    mkdir -p $out/share/applications
    cp usr/share/applications/kapsa.desktop $out/share/applications/${finalAttrs.pname}.desktop
    substituteInPlace $out/share/applications/${finalAttrs.pname}.desktop \
      --replace-fail "/usr/local/lib/${finalAttrs.pname}/kapsa" ${finalAttrs.pname} \
      --replace-fail "Exec=kapsa" "Exec=${finalAttrs.pname}" \
      --replace-fail "Icon=io.kapsa.drive" "Icon=$out/share/icons/${finalAttrs.pname}.svg"


    runHook postInstall
  '';

  meta = with lib; {
    description = "Personal storage compatible with S3, WebDav and 70+ other Rclone back-ends";
    homepage = "https://s3drive.app/";
    license = licenses.unfree;
    maintainers = with maintainers; [ abueide ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = finalAttrs.pname;
  };
})
