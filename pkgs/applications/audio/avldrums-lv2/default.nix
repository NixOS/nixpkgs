{ stdenv, fetchFromGitHub, pkgconfig, pango, cairo, libGLU, lv2 }:

stdenv.mkDerivation rec {
  pname = "avldrums.lv2";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "x42";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z70rcq6z3gkb4fm8dm9hs31bslwr97zdh2n012fzki9b9rdj5qv";
    fetchSubmodules = true;
  };

  installFlags = [ "PREFIX=$(out)" ];

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
