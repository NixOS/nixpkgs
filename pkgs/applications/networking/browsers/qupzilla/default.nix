{ stdenv, fetchFromGitHub, qt5 }:

stdenv.mkDerivation rec {
  name = "qupzilla";
  version = "2.1.2";


  src = fetchFromGitHub {
    owner = "QupZilla";
    repo = "qupzilla";
    rev = "v${version}";
    sha256 = "06s50hynnmb3k42a0a5jg6ql58wv19cskvnzmcmi46wcm676shgy";
  };

  patchPhase = ''
    sed -i 's,d_prefix = .*,d_prefix = '$out',' src/defines.pri
  '';

  nativeBuildInputs = with qt5; [ qmake ];
  buildInputs = with qt5; [ full qtwebengine qtx11extras ];

  meta = with stdenv.lib; {
    inherit (qt5.qtbase.meta) platforms;
    homepage = https://github.com/QupZilla/qupzilla;
    description = "Cross-platform Qt web browser";
    license = licenses.gpl3;
    maintainers = with maintainers; [ disassembler ];
  };

}
