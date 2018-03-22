{ stdenv, fetchFromGitHub, git, gnupg, pass, qtbase, qtsvg, qttools, qmake, makeWrapper }:

stdenv.mkDerivation rec {
  name = "qtpass-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner  = "IJHack";
    repo   = "QtPass";
    rev    = "v${version}";
    sha256 = "0pp38b3fifkfwqcb6vi194ccgb8j3zc8j8jq8ww5ib0wvhldzsg8";
  };

  patches = [ ./hidpi.patch ];

  buildInputs = [ git gnupg pass qtbase qtsvg qttools ];

  nativeBuildInputs = [ makeWrapper qmake ];

  postPatch = ''
    substituteInPlace qtpass.pro --replace "SUBDIRS += src tests main" "SUBDIRS += src main"
    substituteInPlace qtpass.pro --replace "main.depends = tests" "main.depends = src"
  '';

  postInstall = ''
    install -D qtpass.desktop $out/share/applications/qtpass.desktop
    install -D artwork/icon.svg $out/share/icons/hicolor/scalable/apps/qtpass-icon.svg
    wrapProgram $out/bin/qtpass \
      --suffix PATH : ${git}/bin \
      --suffix PATH : ${gnupg}/bin \
      --suffix PATH : ${pass}/bin
  '';

  meta = with stdenv.lib; {
    description = "A multi-platform GUI for pass, the standard unix password manager";
    homepage = https://qtpass.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.hrdinka ];
    platforms = platforms.all;
  };
}
