{ stdenv, fetchFromGitHub, git, gnupg, pass, qtbase, qtsvg, qttools, qmake, makeWrapper }:

stdenv.mkDerivation rec {
  name = "qtpass-${version}";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner  = "IJHack";
    repo   = "QtPass";
    rev    = "v${version}";
    sha256 = "0jq5a1cvqvsjwld0nldl6kmcz9g59hiccmbg98xwji04n8174y7j";
  };

  buildInputs = [ git gnupg pass qtbase qtsvg qttools ];

  nativeBuildInputs = [ makeWrapper qmake ];

  preConfigure = ''
    qmakeFlags="$qmakeFlags DESTDIR=$out"
  '';

  installPhase = ''
    mkdir $out/bin
    mv $out/qtpass $out/bin
    install -D {,$out/share/applications/}qtpass.desktop
    install -D artwork/icon.svg $out/share/icons/hicolor/scalable/apps/qtpass-icon.svg
    runHook postInstall
  '';

  postInstall = ''
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
