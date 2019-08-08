{ stdenv, mkDerivation, fetchFromGitHub, git, gnupg, pass, qtbase, qtsvg, qttools, qmake, makeWrapper }:

mkDerivation rec {
  pname = "qtpass";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner  = "IJHack";
    repo   = "QtPass";
    rev    = "v${version}";
    sha256 = "1vfhfyccrxq9snyvayqfzm5rqik8ny2gysyv7nipc91kvhq3bhky";
  };

  buildInputs = [ git gnupg pass qtbase qtsvg qttools ];

  nativeBuildInputs = [ makeWrapper qmake ];

  enableParallelBuilding = true;

  qtWrapperArgs = [
    "--suffix PATH : ${git}/bin"
    "--suffix PATH : ${gnupg}/bin"
    "--suffix PATH : ${pass}/bin"
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
