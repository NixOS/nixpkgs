{ stdenv, fetchFromGitHub, cmake, qt4, libXfixes, libXtst}:

stdenv.mkDerivation rec {
  name = "CopyQ-${version}";
  version = "2.9.0";

  src  = fetchFromGitHub {
    owner = "hluk";
    repo = "CopyQ";
    rev = "v${version}";
    sha256 = "1gnqsfh50w3qcnbghkpjr5qs42fgl6643lmg4mg4wam8a852s64f";
  };

  nativeBuildInputs = [ cmake ];
  
  buildInputs = [ qt4 libXfixes libXtst ];

  meta = with stdenv.lib; {
    homepage    = https://hluk.github.io/CopyQ;
    description = "Clipboard Manager with Advanced Features";
    license     = licenses.gpl3;
    maintainers = [ maintainers.willtim ];
    # NOTE: CopyQ supports windows and osx, but I cannot test these.
    # OSX build requires QT5.
    platforms   = platforms.linux;
  };
}
