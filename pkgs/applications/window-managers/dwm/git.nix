{ lib, stdenv, fetchgit, libX11, libXinerama, libXft, writeText, patches ? [ ]
, conf ? null }:

stdenv.mkDerivation {
  pname = "dwm-git";
  version = "20200303";

  src = fetchgit {
    url = "git://git.suckless.org/dwm";
    rev = "61bb8b2241d4db08bea4261c82e27cd9797099e7";
    sha256 = "1j3vly8dln35vnwnwwlaa8ql9fmnlmrv43jcyc8dbfhfxiw6f34l";
  };

  buildInputs = [ libX11 libXinerama libXft ];

  prePatch = ''sed -i "s@/usr/local@$out@" config.mk'';

  # Allow users set their own list of patches
  inherit patches;

  # Allow users to set the config.def.h file containing the configuration
  postPatch = let
    configFile = if lib.isDerivation conf || builtins.isPath conf then
      conf
    else
      writeText "config.def.h" conf;
  in lib.optionalString (conf != null) "cp ${configFile} config.def.h";

  meta = with lib; {
    homepage = "https://suckless.org/";
    description = "Dynamic window manager for X, development version";
    license = licenses.mit;
    maintainers = with maintainers; [ xeji ];
    platforms = platforms.unix;
  };
}
