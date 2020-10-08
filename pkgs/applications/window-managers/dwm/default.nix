{stdenv, fetchurl, libX11, libXinerama, libXft, writeText, patches ? [], conf ? null}:

with stdenv.lib;

let
  name = "dwm-6.2";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "https://dl.suckless.org/dwm/${name}.tar.gz";
    sha256 = "03hirnj8saxnsfqiszwl2ds7p0avg20izv9vdqyambks00p2x44p";
  };

  buildInputs = [ libX11 libXinerama libXft ];

  prePatch = ''sed -i "s@/usr/local@$out@" config.mk'';

  # Allow users set their own list of patches
  inherit patches;

  # Allow users to set the config.def.h file containing the configuration
  postPatch = let configFile = if isDerivation conf || builtins.isPath conf then conf else writeText "config.def.h" conf;
  in optionalString (conf!=null) "cp ${configFile} config.def.h";

  meta = {
    homepage = "https://suckless.org/";
    description = "Dynamic window manager for X";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
