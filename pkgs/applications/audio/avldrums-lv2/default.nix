{ stdenv, fetchFromGitHub, pkgconfig, pango, cairo, libGLU, lv2 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "avldrums.lv2";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "x42";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yhq3n5bahhqpj40mvlkxcjsdsw63jsbz20pl77bx2qj30w25i2j";
    fetchSubmodules = true;
  };

  installFlags = "PREFIX=$(out)";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    pango cairo libGLU lv2
  ];

  meta = with stdenv.lib; {
    description = "Dedicated AVLDrumkits LV2 Plugin";
    homepage    = http://x42-plugins.com/x42/x42-avldrums;
    license     = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms   = [ "i686-linux" "x86_64-linux" ];
  };
}
