{ lib, stdenv, qmake, fetchFromGitHub, qtbase, qttools, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "kapow";
  version = "1.5.10";

  src = fetchFromGitHub {
    owner = "gottcode";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fz9fb4w21ax8hjs6dwfn2410ig4lqvzdlijq0jcj3jbgxd4i1gw";
  };

  nativeBuildInputs = [ qmake qttools wrapQtAppsHook ];

  buildInputs = [ qtbase ];

  meta = with lib; {
    description = "Punch clock to track time spent on projects";
    mainProgram = "kapow";
    homepage = "https://gottcode.org/kapow/";
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
