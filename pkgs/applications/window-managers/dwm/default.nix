{stdenv, fetchurl, libX11, libXinerama, patches ? []}:

let
  name = "dwm-6.0";
in
stdenv.mkDerivation {
  inherit name;
 
  src = fetchurl {
    url = "http://dl.suckless.org/dwm/${name}.tar.gz";
    sha256 = "0mpbivy9j80l1jqq4bd4g4z8s5c54fxrjj44avmfwncjwqylifdj";
  };
 
  buildInputs = [ libX11 libXinerama ];
 
  prePatch = ''sed -i "s@/usr/local@$out@" config.mk'';

  # Allow users set their own list of patches
  inherit patches;

  buildPhase = " make ";
 
  meta = {
    homepage = "www.suckless.org";
    description = "Dynamic window manager for X";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
