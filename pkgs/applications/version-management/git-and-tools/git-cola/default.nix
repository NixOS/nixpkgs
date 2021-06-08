{ lib, fetchFromGitHub, fetchpatch, python3Packages, gettext, git, qt5 }:

let
  inherit (python3Packages) buildPythonApplication pyqt5 sip_4 pyinotify;

in buildPythonApplication rec {
  pname = "git-cola";
  version = "3.9";

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    rev = "v${version}";
    sha256 = "11186pdgaw5p4iv10dqcnynf5pws2v9nhqqqca7z5b7m20fpfjl7";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/git-cola/git-cola/commit/bdd6121f795186bbed9335995ef77a47ed007092.patch";
      sha256 = "sha256-mTOGWatIcKB8+DBh5wu1GfcP1LZDiQjhAshlVgguKdk=";
      name = "bdd6121f795186bbed9335995ef77a47ed007092.patch";
    })
  ];

  buildInputs = [ git gettext ];
  propagatedBuildInputs = [ pyqt5 sip_4 pyinotify ];
  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  doCheck = false;

  postFixup = ''
    wrapQtApp $out/bin/git-cola
    wrapQtApp $out/bin/git-dag

  '';

  meta = with lib; {
    homepage = "https://github.com/git-cola/git-cola";
    description = "A sleek and powerful Git GUI";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bobvanderlinden ];
  };
}
