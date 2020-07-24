{ stdenv, fetchFromGitHub
, doxygen, graphviz, libX11, libXrandr }:

stdenv.mkDerivation rec {

  pname = "smallwm";
  version = "2020-02-28";

  src = fetchFromGitHub {
    owner = "adamnew123456";
    repo = "SmallWM";
    rev = "c2dc72afa87241bcf7e646630f4aae216ce78613";
    sha256 = "0cqhy81ymdcdyvgi55a401rr96h2akskcxi9ddzjbln4a71yjlz8";
  };

  nativeBuildInputs = [ doxygen graphviz ];
  buildInputs = [ libX11 libXrandr ];

  dontConfigure = true;

  makeFlags = [ "CC=${stdenv.cc}/bin/cc" "CXX=${stdenv.cc}/bin/c++" ];

  buildFlags = [ "all" "doc" ];

  installPhase = ''
    install -dm755 $out/bin $out/share/doc/${pname}-${version}
    install -m755 bin/smallwm -t $out/bin
    cp -r README.markdown doc/html doc/latex $out/share/doc/${pname}-${version}
  '';

  meta = with stdenv.lib;{
    description = "A small X window manager, extended from tinywm";
    homepage = "https://github.com/adamnew123456/SmallWM";
    license = licenses.bsd2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
