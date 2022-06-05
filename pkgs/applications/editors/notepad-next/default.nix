{ mkDerivation, lib, fetchFromGitHub, qmake, libsForQt5, stdenv }:

mkDerivation rec {
  pname = "notepad-next";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "dail8859";
    repo = "NotepadNext";
    rev = "v${version}";
    sha256 = "sha256-J7Ngt6YtAAZsza2lN0d1lX3T8gNJHp60sCwwaLMGBHQ=";
    # External dependencies - https://github.com/dail8859/NotepadNext/issues/135
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qmake libsForQt5.qt5.qttools ];
  qmakeFlags = [ "src/NotepadNext.pro" ];

  # References
  #  https://github.com/dail8859/NotepadNext/blob/master/doc/Building.md
  #  https://github.com/dail8859/NotepadNext/pull/124
  postPatch = ''
    substituteInPlace ./src/NotepadNext/NotepadNext.pro --replace /usr $out
  '';

  # Upstream suggestion: https://github.com/dail8859/NotepadNext/issues/135
  CXXFLAGS = "-std=gnu++1z";

  meta = with lib; {
    homepage = "https://github.com/dail8859/NotepadNext";
    description = "Notepad++-like editor for the Linux desktop";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.sebtm ];
    broken = stdenv.isAarch64;
  };
}
