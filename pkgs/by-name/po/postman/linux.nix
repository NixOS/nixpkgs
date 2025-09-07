{
  lib,
  stdenv,
  copyDesktopItems,
  makeWrapper,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  curlWithGnuTls,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libX11,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXScrnSaver,
  libXtst,
  libdrm,
  libgbm,
  libGL,
  libsecret,
  libuuid,
  libxkbcommon,
  nspr,
  nss,
  pango,
  udev,
  xorg,
  bintools,
  makeDesktopItem,
  # It's unknown which version of openssl that postman expects but it seems that
  # OpenSSL 3+ seems to work fine (cf.
  # https://github.com/NixOS/nixpkgs/issues/254325). If postman breaks apparently
  # around OpenSSL stuff then try changing this dependency version.
  openssl,
  pname,
  version,
  src,
  passthru,
  meta,
}:

stdenv.mkDerivation {
  inherit
    pname
    version
    src
    passthru
    meta
    ;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "postman";
      exec = "postman %U";
      icon = "postman";
      comment = "API Development Environment";
      desktopName = "Postman";
      genericName = "Postman";
      categories = [ "Development" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share $out/bin
    cp --recursive app $out/share/postman
    rm $out/share/postman/Postman
    makeWrapper $out/share/postman/postman $out/bin/postman \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --prefix PATH : ${lib.makeBinPath [ openssl ]}
    mkdir -p $out/share/icons/hicolor/128x128/apps
    ln -s $out/share/postman/resources/app/assets/icon.png $out/share/icons/postman.png
    ln -s $out/share/postman/resources/app/assets/icon.png $out/share/icons/hicolor/128x128/apps/postman.png

    runHook postInstall
  '';

  postFixup = ''
    patchelf --set-interpreter ${bintools.dynamicLinker} --add-needed libGL.so.1 $out/share/postman/postman
    patchelf --set-interpreter ${bintools.dynamicLinker} $out/share/postman/chrome_crashpad_handler
    for file in $(find $out/share/postman -type f \( -name \*.node -o -name postman -o -name \*.so\* \) ); do
      patchelf --add-rpath "${
        lib.makeLibraryPath [
          (lib.getLib stdenv.cc.cc)
          alsa-lib
          atk
          at-spi2-atk
          at-spi2-core
          cairo
          cups
          curlWithGnuTls
          dbus
          expat
          fontconfig
          freetype
          gdk-pixbuf
          glib
          gtk3
          libdrm
          libgbm
          libGL
          libsecret
          libuuid
          libX11
          libXcomposite
          libXcursor
          libXdamage
          libXext
          libXfixes
          libXi
          libXrandr
          libXrender
          libXScrnSaver
          libxkbcommon
          libXtst
          nspr
          nss
          pango
          udev
          xorg.libxcb
          xorg.libxshmfence
        ]
      }" $file
    done
  '';
}
