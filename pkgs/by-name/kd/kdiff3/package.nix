{
  stdenv,
  lib,
  fetchurl,
  boost,
  cmake,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdiff3";
  version = "1.12.4";

  src = fetchurl {
    url = "mirror://kde/stable/kdiff3/kdiff3-${finalAttrs.version}.tar.xz";
    hash = "sha256-RpCjWqkzsZJ1HdWQprT1P+86qVAkY3ERKtbocvaybss=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.kdoctools
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = with kdePackages; [
    qtbase
    boost
    kconfig
    kcrash
    kparts
    kiconthemes
  ];

  cmakeFlags = [ "-Wno-dev" ];

  env.LANG = "C.UTF-8";

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    ln -s "$out/Applications/KDE/kdiff3.app/Contents/MacOS" "$out/bin"
  '';

  meta = {
    description = "Compares and merges 2 or 3 files or directories";
    mainProgram = "kdiff3";
    homepage = "https://invent.kde.org/sdk/kdiff3";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ peterhoeg ];
    inherit (kdePackages.qtbase.meta) platforms;
  };
})
