{stdenv, fetchgit, xproto, libX11, enableXft, libXft}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "tabbed-20150509";

  src = fetchgit {
    url = http://git.suckless.org/tabbed;
    rev = "55dc32b27b73c121cab18009bf087e95ef3d9c18";
    sha256 = "0c5ayf1lrb1xiz5h8dfd4mh05kas42zzi5m5ylrvl67sfz3z4wg1";
  };

  patches = optional enableXft ./xft.patch;

  buildInputs = [ xproto libX11 ] ++ optional enableXft libXft;

  preInstall = ''
    export makeFlags="PREFIX=$out"
  '';

  meta = {
    homepage = http://tools.suckless.org/tabbed;
    description = "Simple generic tabbed fronted to xembed aware applications";
    license = licenses.mit;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.linux;
  };
}
