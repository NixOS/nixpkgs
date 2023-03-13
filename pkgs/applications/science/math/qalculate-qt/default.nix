{ lib, stdenv, fetchFromGitHub, intltool, pkg-config, qmake, wrapQtAppsHook, libqalculate, qtbase, qttools, qtsvg, qtwayland }:

stdenv.mkDerivation rec {
  pname = "qalculate-qt";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-qt";
    rev = "v${version}";
    hash = "sha256-/TDzjlB8rW/TorndcLbxY9pc3q7vY3M6eLxBRfnBs9Y=";
  };

  nativeBuildInputs = [ qmake intltool pkg-config wrapQtAppsHook ];
  buildInputs = [ libqalculate qtbase qttools qtsvg qtwayland ];

  postPatch = ''
    substituteInPlace qalculate-qt.pro\
      --replace "LRELEASE" "${qttools.dev}/bin/lrelease"
  '';

  meta = with lib; {
    description = "The ultimate desktop calculator";
    homepage = "http://qalculate.github.io";
    maintainers = with maintainers; [ _4825764518 ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
