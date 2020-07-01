{ fetchgit, libcommuni, qtbase, qmake, stdenv }:

stdenv.mkDerivation rec {
  pname = "communi";
  version = "3.5.0";

  src = fetchgit {
    url = "https://github.com/communi/communi-desktop.git";
    rev = "v${version}";
    sha256 = "10grskhczh8601s90ikdsbjabgr9ypcp2j7vivjkl456rmg6xbji";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qmake ];

  buildInputs = [ libcommuni qtbase ];

  enableParallelBuilding = true;

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

  postInstall = stdenv.lib.optionalString stdenv.isLinux ''
    substituteInPlace "$out/share/applications/communi.desktop" \
      --replace "/usr/bin" "$out/bin"
  '';

  preFixup = ''
    rm -rf lib
  '';

  meta = with stdenv.lib; {
    description = "A simple and elegant cross-platform IRC client";
    homepage = "https://github.com/communi/communi-desktop";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hrdinka ];
    platforms = platforms.all;
  };
}
