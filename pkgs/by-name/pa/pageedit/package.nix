{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pageedit";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "Sigil-Ebook";
    repo = "pageedit";
    tag = finalAttrs.version;
    hash = "sha256-oC4OMYTFXIoLCstAalyJb4ppstmSTiE+mdmqhOY6FUU=";
  };

  nativeBuildInputs = with qt6Packages; [
    cmake
    wrapQtAppsHook
    qttools
  ];

  propagatedBuildInputs = with qt6Packages; [
    qtsvg
    qtwebengine
  ];

  cmakeFlags = [ "-DINSTALL_BUNDLED_DICTS=0" ];

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/Applications
        cp -r bin/PageEdit.app $out/Applications
        makeWrapper $out/Applications/PageEdit.app/Contents/MacOS/PageEdit $out/bin/pageedit

        runHook postInstall
      ''
    else
      null;

  meta = {
    description = "EPUB XHTML Visual Editor";
    mainProgram = "pageedit";
    homepage = "https://sigil-ebook.com/pageedit/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.pasqui23 ];
    platforms = lib.platforms.all;
  };
})
