{ stdenv, fetchgit, pkgconfig, libXcomposite, libXfixes, libXdamage
, libXrender, libXext }:
stdenv.mkDerivation rec {
  name = "compton-20120507";
  src = fetchgit {
    url = git://github.com/chjj/compton.git;
    rev = "d52f7a06dbc55d92e061f976730952177edac739";
    sha256 = "0f7600a841c4c77d181b54bc14cf7d90d0bad25aa5edbade320ca8b9946f14eb";
  };
  buildInputs = [ pkgconfig libXcomposite libXfixes libXdamage libXrender libXext ];
  buildFlagsArray = ["CFLAGS=-O3 -fomit-frame-pointer"];
  installFlags = "PREFIX=$(out)";
  meta = {
    homepage = http://www.x.org/;
    description = "A fork of XCompMgr, a sample compositing manager for X servers";
    longDescription = ''
      A fork of XCompMgr, which is a  sample compositing manager for X servers
      supporting the XFIXES, DAMAGE, RENDER, and COMPOSITE extensions.  It enables
      basic eye-candy effects. This fork adds additional features, such as additional
      effects, and a fork at a well-defined and proper place.
    '';
    license = "bsd";
    platforms = with stdenv.lib.platforms; linux;
  };
}
