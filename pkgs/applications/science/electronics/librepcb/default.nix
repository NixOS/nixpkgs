{ stdenv, lib, fetchFromGitHub
, qtbase, qttools, qmake, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "librepcb";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = version;
    sha256 = "0ag8h3id2c1k9ds22rfrvyhf2vjhkv82xnrdrz4n1hnlr9566vcx";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qmake qttools wrapQtAppsHook ];
  buildInputs = [ qtbase ];

  qmakeFlags = ["-r"];

  # the build system tries to use 'git' at build time to find the HEAD hash.
  # that's a no-no, so replace it with a quick hack. NOTE: the # adds a comment
  # at the end of the line to remove the git call.
  postPatch = ''
    substituteInPlace ./libs/librepcb/common/common.pro \
      --replace 'GIT_COMMIT_SHA' 'GIT_COMMIT_SHA="\\\"${src.rev}\\\"" # '
  '';

  postInstall = ''
    mkdir -p $out/share/librepcb/fontobene
    cp share/librepcb/fontobene/newstroke.bene $out/share/librepcb/fontobene/
  '';

  meta = with lib; {
    description = "A free EDA software to develop printed circuit boards";
    homepage    = "https://librepcb.org/";
    maintainers = with maintainers; [ luz thoughtpolice ];
    license     = licenses.gpl3Plus;
    platforms   = platforms.linux;
  };
}
