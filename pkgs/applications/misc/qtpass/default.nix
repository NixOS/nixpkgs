{ stdenv, fetchzip, git, gnupg, makeQtWrapper, pass, qtbase, qtsvg, qttools, qmakeHook }:

stdenv.mkDerivation rec {
  name = "qtpass-${version}";
  version = "1.1.1";

  src = fetchzip {
    url = "https://github.com/IJHack/qtpass/archive/v${version}.tar.gz";
    sha256 = "1x1ic9as0a60gz664sf8d1qiq64ji7q60g19x0rlm3bvcp2612c8";
  };

  buildInputs = [ git gnupg pass qtbase qtsvg qttools ];

  nativeBuildInputs = [ makeQtWrapper qmakeHook ];

  preConfigure = ''
    qmakeFlags="$qmakeFlags CONFIG+=release DESTDIR=$out"
  '';

  installPhase = ''
    mkdir $out/bin
    mv $out/qtpass $out/bin
    install -D {,$out/share/applications/}qtpass.desktop
    install -D artwork/icon.svg $out/share/icons/hicolor/scalable/apps/qtpass-icon.svg
    runHook postInstall
  '';

  postInstall = ''
    wrapQtProgram $out/bin/qtpass \
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
