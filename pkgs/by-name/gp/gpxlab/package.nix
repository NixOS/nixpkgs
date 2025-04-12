{
  stdenv,
  lib,
  fetchFromGitHub,
  qt5,
}:

stdenv.mkDerivation rec {
  pname = "gpxlab";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "BourgeoisLab";
    repo = "GPXLab";
    rev = "v${version}";
    sha256 = "080vnwcciqblfrbfyz9gjhl2lqw1hkdpbgr5qfrlyglkd4ynjd84";
  };

  nativeBuildInputs = [
    qt5.qmake
    qt5.qttools
    qt5.wrapQtAppsHook
  ];

  preConfigure = ''
    lrelease GPXLab/locale/*.ts
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv GPXLab/GPXLab.app $out/Applications

    mkdir -p $out/bin
    ln -s $out/Applications/GPXLab.app/Contents/MacOS/GPXLab $out/bin/gpxlab
  '';

  meta = with lib; {
    homepage = "https://github.com/BourgeoisLab/GPXLab";
    description = "Program to show and manipulate GPS tracks";
    mainProgram = "gpxlab";
    longDescription = ''
      GPXLab is an application to display and manage GPS tracks
      previously recorded with a GPS tracker.
    '';
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
