{ fetchgit, libcommuni, makeQtWrapper, qtbase, qmakeHook, stdenv }:

stdenv.mkDerivation rec {
  name = "communi-${version}";
  version = "2016-01-03";

  src = fetchgit {
    url = "https://github.com/communi/communi-desktop.git";
    rev = "ad1b9a30ed6c51940c0d2714b126a32b5d68c876";
    sha256 = "0gk6gck09zb44qfsal7bs4ln2vl9s9x3vfxh7jvfc7mmf7l3sspd";
  };

  nativeBuildInputs = [ makeQtWrapper qmakeHook ];

  buildInputs = [ libcommuni qtbase ];

  enableParallelBuild = true;

  preConfigure = ''
    export QMAKEFEATURES=${libcommuni}/features
    qmakeFlags="$qmakeFlags \
      COMMUNI_INSTALL_PREFIX=$out \
      COMMUNI_INSTALL_BINS=$out/bin \
      COMMUNI_INSTALL_PLUGINS=$out/lib/communi/plugins \
      COMMUNI_INSTALL_ICONS=$out/share/icons/hicolor \
      COMMUNI_INSTALL_DESKTOP=$out/share/applications \
      COMMUNI_INSTALL_THEMES=$out/share/communi/themes
    "
  '';

  postInstall = ''
    wrapQtProgram "$out/bin/communi"
    substituteInPlace "$out/share/applications/communi.desktop" \
      --replace "/usr/bin" "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "A simple and elegant cross-platform IRC client";
    homepage = https://github.com/communi/communi-desktop;
    license = licenses.bsd3;
    maintainers = with maintainers; [ hrdinka ];
    platforms = platforms.all;
  };
}
