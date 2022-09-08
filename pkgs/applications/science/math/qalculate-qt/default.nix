{ lib, stdenv, fetchFromGitHub, intltool, pkg-config, qmake, wrapQtAppsHook, libqalculate, qtbase, qttools }:

stdenv.mkDerivation rec {
  pname = "qalculate-qt";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-qt";
    rev = "v${version}";
    sha256 = "sha256-zznLCTbHX7VDMgW3b709snxSEtoF8k4xJBk3MdgFPNk=";
  };

  nativeBuildInputs = [ qmake intltool pkg-config wrapQtAppsHook ];
  buildInputs = [ libqalculate qtbase qttools ];

  meta = with lib; {
    description = "The ultimate desktop calculator";
    homepage = "http://qalculate.github.io";
    maintainers = with maintainers; [ _4825764518 ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
  };
}
