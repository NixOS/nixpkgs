{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qtsvg,
  qtwebengine,
  wrapQtAppsHook,
  qttools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pageedit";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "Sigil-Ebook";
    repo = "pageedit";
    tag = finalAttrs.version;
    hash = "sha256-BsK+agn8O2WeftiEHfT5B1hzsP5Av4DkIZqVKoQxb70=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
    qttools
  ];

  propagatedBuildInputs = [
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
    description = "ePub XHTML Visual Editor";
    mainProgram = "pageedit";
    homepage = "https://sigil-ebook.com/pageedit/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.pasqui23 ];
    platforms = lib.platforms.all;
  };
})
