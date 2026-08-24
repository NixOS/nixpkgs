{
  lib,
  stdenv,
  cmake,
  kdePackages,
  recoll,
  xapian,
}:

stdenv.mkDerivation {
  pname = "recoll-krunner";
  inherit (recoll) src version;

  strictDeps = true;
  buildInputs = [
    kdePackages.kio
    kdePackages.krunner
    recoll
    xapian
  ];

  postPatch = ''
    cp ./kde/krunner/CMakeLists-KF6.txt ./kde/krunner/CMakeLists.txt
  '';

  dontWrapQtApps = true;

  nativeBuildInputs = [ cmake ];

  cmakeDir = "../kde/krunner";

  __structuredAttrs = true;
  meta = {
    inherit (recoll.meta) homepage license;
    description = "Krunner plugin for recoll";
    maintainers = with lib.maintainers; [ numkem ];
    platforms = lib.platforms.linux;
  };
}
