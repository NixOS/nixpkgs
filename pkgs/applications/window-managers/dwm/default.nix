{stdenv, fetchurl, libX11, libXinerama, libXft, patches ? []}:

let
  name = "dwm-6.1";
in
stdenv.mkDerivation {
  inherit name;
 
  src = fetchurl {
    url = "http://dl.suckless.org/dwm/${name}.tar.gz";
    sha256 = "1zkmwb6df6m254shx06ly90c0q4jl70skk1pvkixpb7hcxhwbxn2";
  };
 
  buildInputs = [ libX11 libXinerama libXft ];
 
  prePatch = ''sed -i "s@/usr/local@$out@" config.mk'';

  # Allow users set their own list of patches
  inherit patches;

  buildPhase = " make ";
 
  meta = {
    homepage = "http://suckless.org/";
    description = "Dynamic window manager for X";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
