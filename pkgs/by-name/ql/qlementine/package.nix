{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "qlementine";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "oclero";
    repo = "qlementine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-emP/ln69xdmoRDTKfSCTuv/H7HE4H6Mp7HPjvxjpphw=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
  ];

  dontWrapQtApps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern QStyle for desktop Qt6 applications";
    longDescription = ''
      A QStyle for desktop Qt6 applications.

      This library contains:

      - A custom QStyle named QlementineStyle, that implements all the
        necessary API to give a modern look and feel to your Qt
        application. It's a drop-in replacement for the default QStyle.

      - Lots of utilities to help you write beautiful QWidgets that fits
        well with the style.

      - A collection of new QWidgets that are missing in Qt's standard
        collection, such as Switch.
    '';
    homepage = "https://oclero.github.io/qlementine/";
    changelog = "https://github.com/oclero/qlementine/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ normalcea ];
    platforms = lib.platforms.unix;
  };
})
