{ fetchgit, libcommuni, makeQtWrapper, qtbase, qmakeHook, stdenv }:

stdenv.mkDerivation rec {
  name = "communi-${version}";
  version = "2016-08-19";

  src = fetchgit {
    url = "https://github.com/communi/communi-desktop.git";
    rev = "d516b01b1382a805de65f21f3475e0a8e64a97b5";
    sha256 = "1pn7mr7ch1ck5qv9zdn3ril40c9kk6l04475564rpzf11jly76an";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ makeQtWrapper qmakeHook ];

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

  postInstall = ''
    wrapQtProgram "$out/bin/communi"
    substituteInPlace "$out/share/applications/communi.desktop" \
      --replace "/usr/bin" "$out/bin"
  '';

  postFixup = ''
    patchelf --set-rpath "$out/lib:$(patchelf --print-rpath $out/bin/.communi-wrapped)" $out/bin/.communi-wrapped
  '';

  meta = with stdenv.lib; {
    description = "A simple and elegant cross-platform IRC client";
    homepage = https://github.com/communi/communi-desktop;
    license = licenses.bsd3;
    maintainers = with maintainers; [ hrdinka ];
    platforms = platforms.all;
  };
}
