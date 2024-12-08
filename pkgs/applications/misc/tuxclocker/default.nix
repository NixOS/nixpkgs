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
, tuxclocker-without-unfree
, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tuxclocker";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "Lurkki14";
    repo = "tuxclocker";
    fetchSubmodules = true;
    rev = finalAttrs.version;
    hash = "sha256-QLKLqTCpVMWxlDINa8Bo1vgCDcjwovoaXUs/PdMnxv0=";
  };

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

  passthru.tests = {
    inherit tuxclocker-without-unfree;
  };

  meta = with lib; {
    description = "Qt overclocking tool for GNU/Linux";
    homepage = "https://github.com/Lurkki14/tuxclocker";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lurkki ];
    platforms = platforms.linux;
  };
})
