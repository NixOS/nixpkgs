{ mkDerivation, lib, fetchFromGitHub, qmake, qttools }:

mkDerivation rec {
  pname = "gpxsee";
  version = "7.12";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    sha256 = "0c3axs3mm6xzabwbvy9vgq1sryjpi4h91nwzy9iyv9zjxz7phgzc";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qttools ];

  preConfigure = ''
    lrelease lang/*.ts
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
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };
}
