{ stdenv, mkDerivation, lib, fetchFromGitHub, qmake, qttools, qttranslations }:

mkDerivation rec {
  pname = "gpxlab";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "BourgeoisLab";
    repo = "GPXLab";
    rev = "v${version}";
    sha256 = "080vnwcciqblfrbfyz9gjhl2lqw1hkdpbgr5qfrlyglkd4ynjd84";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qttools qttranslations ];

  preConfigure = ''
    lrelease GPXLab/locale/*.ts
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv GPXLab/GPXLab.app $out/Applications
    wrapQtApp $out/Applications/GPXLab.app/Contents/MacOS/GPXLab
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/BourgeoisLab/GPXLab";
    description = "Program to show and manipulate GPS tracks";
    longDescription = ''
      GPXLab is an application to display and manage GPS tracks
      previously recorded with a GPS tracker.
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ sikmir ];
    platforms = with platforms; linux ++ darwin;
  };
}
