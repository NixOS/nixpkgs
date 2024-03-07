{ lib
, stdenv
, boost
, fetchFromGitHub
, git
, makeWrapper
, meson
, ninja
, pkg-config
, python3
, qtbase
, qtcharts
, tuxclocker-plugins
, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tuxclocker";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "Lurkki14";
    repo = "tuxclocker";
    fetchSubmodules = true;
    rev = "${finalAttrs.version}";
    hash = "sha256-8dtuZXBWftXNQpqYgNQOayPGfvEIu9QfbqDShfkt1qA=";
  };

  # Meson doesn't find boost without these
  BOOST_INCLUDEDIR = "${lib.getDev boost}/include";
  BOOST_LIBRARYDIR = "${lib.getLib boost}/lib";

  nativeBuildInputs = [
    git
    makeWrapper
    meson
    ninja
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    boost
    qtbase
    qtcharts
  ];

  postInstall = ''
    wrapProgram "$out/bin/tuxclockerd" \
      --prefix "TEXTDOMAINDIR" : "${tuxclocker-plugins}/share/locale" \
      --prefix "TUXCLOCKER_PLUGIN_PATH" : "${tuxclocker-plugins}/lib/tuxclocker/plugins" \
      --prefix "PYTHONPATH" : "${python3.pkgs.hwdata}/${python3.sitePackages}"
  '';

  mesonFlags = [
    "-Dplugins=false"
  ];

  meta = with lib; {
    description = "Qt overclocking tool for GNU/Linux";
    homepage = "https://github.com/Lurkki14/tuxclocker";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lurkki ];
    platforms = platforms.linux;
  };
})
