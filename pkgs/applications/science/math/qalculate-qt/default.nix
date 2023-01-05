{ lib, stdenv, fetchFromGitHub, intltool, pkg-config, qmake, wrapQtAppsHook, libqalculate, qtbase, qttools }:

stdenv.mkDerivation rec {
  pname = "qalculate-qt";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-qt";
    rev = "v${version}";
    sha256 = "sha256-1MU/Wici+NQWbjoNpE9q6jKx8aKt85OAfb+ZsN/oK5w=";
  };

  nativeBuildInputs = [ qmake intltool pkg-config wrapQtAppsHook ];
  buildInputs = [ libqalculate qtbase qttools ];

  meta = with lib; {
    description = "The ultimate desktop calculator";
    homepage = "http://qalculate.github.io";
    maintainers = with maintainers; [ _4825764518 ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
