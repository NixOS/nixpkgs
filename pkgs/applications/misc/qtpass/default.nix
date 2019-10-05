{ lib, mkDerivation, fetchFromGitHub
, git, gnupg, pass, pwgen
, qtbase, qtsvg, qttools, qmake
}:

mkDerivation rec {
  pname = "qtpass";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner  = "IJHack";
    repo   = "QtPass";
    rev    = "v${version}";
    sha256 = "025sdk4fq71jgfs54zj7ssgvlci8vvjkqdckgbwz0nqrynlljy08";
  };

  buildInputs = [ git gnupg pass qtbase qtsvg ];

  nativeBuildInputs = [ qmake qttools ];

  enableParallelBuilding = true;

  qmakeFlags = [
    # setup hook only sets QMAKE_LRELEASE, set QMAKE_LUPDATE too:
    "QMAKE_LUPDATE=${qttools.dev}/bin/lupdate"
  ];

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ git gnupg pass pwgen ]}"
  ];

  postInstall = ''
    install -D qtpass.desktop -t $out/share/applications
    install -D artwork/icon.svg $out/share/icons/hicolor/scalable/apps/qtpass-icon.svg
    install -D qtpass.1 -t $out/share/man/man1
  '';

  meta = with lib; {
    description = "A multi-platform GUI for pass, the standard unix password manager";
    homepage = https://qtpass.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.hrdinka ];
    platforms = platforms.all;
  };
}
