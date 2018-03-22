{ stdenv, libX11, fetchurl }:

stdenv.mkDerivation rec {
  name = "worker-${version}";
  version = "3.15.0";

  src = fetchurl {
    url = "http://www.boomerangsworld.de/cms/worker/downloads/${name}.tar.gz";
    sha256 = "0baaxa10jnf4nralhjdi7525wd1wj0161z2ixz1j5pb0rl38brl8";
  };

  buildInputs = [ libX11 ];

  meta = with stdenv.lib; {
    description = "A two-pane file manager with advanced file manipulation features";
    homepage = http://www.boomerangsworld.de/cms/worker/index.html;
    license =  licenses.gpl2;
    maintainers = [ maintainers.ndowens ];
  };
}
