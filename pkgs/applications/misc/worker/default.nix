{pkgs, stdenv, xorg, fetchurl }:

stdenv.mkDerivation rec {
  name = "worker";
  version = "3.8.5";

  src = fetchurl {
    url = "http://www.boomerangsworld.de/cms/worker/downloads/${name}-${version}.tar.gz";
    sha256 = "1xy02jdf60wg2jycinl6682xg4zvphdj80f8xgs26ip45iqgkmvw";
  };

  buildInputs = with pkgs; [ xorg.libX11 ];

  meta = with stdenv.lib; {
    description = "a two-pane file manager with advanced file manipulation features";
    homepage = "http://www.boomerangsworld.de/cms/worker/index.html";
    license =  licenses.gpl2;
    maintainers = [ maintainers.ndowens ];
  };
}
