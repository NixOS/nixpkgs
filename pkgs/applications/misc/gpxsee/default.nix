{ stdenv, mkDerivation, lib, fetchFromGitHub, qmake, qttools }:

mkDerivation rec {
  pname = "gpxsee";
  version = "7.22";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    sha256 = "0gxkx255d8cn5076ync731cdygwvi95rxv463pd4rdw5srbr0gm5";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qttools ];

  preConfigure = ''
    lrelease lang/*.ts
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv GPXSee.app $out/Applications
    wrapQtApp $out/Applications/GPXSee.app/Contents/MacOS/GPXSee
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = https://www.gpxsee.org/;
    description = "GPS log file viewer and analyzer";
    longDescription = ''
      GPXSee is a Qt-based GPS log file viewer and analyzer that supports
      all common GPS log file formats.
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ womfoo sikmir ];
    platforms = with platforms; linux ++ darwin;
  };
}
