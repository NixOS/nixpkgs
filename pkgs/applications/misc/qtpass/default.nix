{ stdenv, lib, mkDerivation, fetchFromGitHub
, git, gnupg, pass, qtbase, qtsvg, qttools, qmake
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

  buildInputs = [ git gnupg pass qtbase qtsvg qttools ];

  nativeBuildInputs = [ qmake ];

  enableParallelBuilding = true;

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ git gnupg pass ]}"
  ];

  postInstall = ''
    install -D qtpass.desktop $out/share/applications/qtpass.desktop
    install -D artwork/icon.svg $out/share/icons/hicolor/scalable/apps/qtpass-icon.svg
  '';

  meta = with stdenv.lib; {
    description = "A multi-platform GUI for pass, the standard unix password manager";
    homepage = https://qtpass.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.hrdinka ];
    platforms = platforms.all;
  };
}
