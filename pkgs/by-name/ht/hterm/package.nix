{
  stdenv,
  lib,
  fetchurl,
  cairo,
  pango,
  libpng,
  expat,
  fontconfig,
  gtk2,
  xorg,
  autoPatchelfHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hterm";
  version = "0.8.9";

  src =
    let
      versionWithoutDots = builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version;
    in
    if stdenv.targetPlatform.is64bit then
      fetchurl {
        url = "https://www.der-hammer.info/terminal/hterm${versionWithoutDots}-linux-64.tgz";
        hash = "sha256-DY+X7FaU1UBbNf/Kgy4TzBZiocQ4/TpJW3KLW1iu0M0=";
      }
    else
      fetchurl {
        url = "https://www.der-hammer.info/terminal/hterm${versionWithoutDots}-linux-32.tgz";
        hash = "sha256-7wJFCpeXNMX94tk0QVc0T22cbv3ODIswFge5Cs0JhI8=";
      };
  sourceRoot = ".";

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    cairo
    pango
    libpng
    expat
    fontconfig.lib
    gtk2
    xorg.libSM
  ];

  installPhase = ''
    runHook preInstall
    install -m755 -D hterm $out/bin/hterm
    install -m644 -D desktop/hterm.png $out/share/pixmaps/hterm.png
    install -m644 -D desktop/hterm.desktop $out/share/applications/hterm.desktop
    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://www.der-hammer.info/pages/terminal.html";
    changelog = "https://www.der-hammer.info/terminal/CHANGELOG.txt";
    description = "Terminal program for serial communication";
    # See https://www.der-hammer.info/terminal/LICENSE.txt
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = with lib.maintainers; [ zebreus ];
    mainProgram = "hterm";
  };
})
