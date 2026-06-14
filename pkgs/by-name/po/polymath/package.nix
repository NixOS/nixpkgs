{
  lib,
  stdenv,
  fetchurl,

  dpkg,
  autoPatchelfHook,
  makeWrapper,

  atk,
  coreutils,
  glib,
  gnugrep,
  xprop,
  libayatana-appindicator,
  libsecret,
  libusb1,
  mpv,
}:
stdenv.mkDerivation (finalAttrs: {
  strictDeps = true;
  __structuredAttrs = true;

  pname = "polymath";
  version = "1.4.3.1";

  src = fetchurl {
    url = "https://fluxkeyboard.com/updates/polymath/linux/deb/polymath_${finalAttrs.version}_amd64.deb";
    hash = "sha256-cCgG2qwVmkFsIhLdxiMtTCul4Dh2za+zptoKhYKJ3fM=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];
  buildInputs = [
    atk
    glib
    libayatana-appindicator
    libsecret
    libusb1
    mpv
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv usr/* $out/
    rmdir usr
    mv ./* $out/

    # Move Pixmaps to icons folder
    mkdir -p $out/share/icons/hicolor/512x512/apps
    mv $out/share/pixmaps/polymath.png $out/share/icons/hicolor/512x512/apps/
    rmdir $out/share/pixmaps

    makeWrapper $out/opt/polymath/polymath $out/bin/polymath \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            gnugrep
            xprop
          ]
        } \
        --prefix LD_LIBRARY_PATH : $out/opt/polymath/lib

    # Fix Paths in Desktop file
    substituteInPlace $out/share/applications/com.fluxkeyboard.polymath.desktop \
      --replace-fail "Exec=/opt/polymath/polymath" "Exec=polymath" \
      --replace-fail "Icon=/usr/share/pixmaps/polymath.png" "Icon=polymath"

    runHook postInstall
  '';

  meta = {
    description = "Flux Keyboard Software";
    longDescription = "Software to configure and control the Flux Keyboard";
    homepage = "https://fluxkeyboard.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "polymath";
    maintainers = with lib.maintainers; [
      darkjaguar91
      michailik
      BatteredBunny
    ];
    platforms = [ "x86_64-linux" ];
  };
})
