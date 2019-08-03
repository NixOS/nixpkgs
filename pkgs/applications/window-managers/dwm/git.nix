{ stdenv, fetchgit, libX11, libXinerama, libXft, patches ? [], conf ? null }:

let
  name = "dwm-git-20180602";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchgit {
    url = "git://git.suckless.org/dwm";
    rev = "b69c870a3076d78ab595ed1cd4b41cf6b03b2610";
    sha256 = "10i079h79l4gdch1qy2vrrb2xxxkgkjmgphr5r9a75jbbagwvz0k";
  };

  buildInputs = [ libX11 libXinerama libXft ];

  prePatch = ''sed -i "s@/usr/local@$out@" config.mk'';

  # Allow users set their own list of patches
  inherit patches;

  # Allow users to override the entire config file AFTER appying the patches
  postPatch = stdenv.lib.optionalString (conf!=null) ''
    echo -n '${conf}' > config.def.h
  '';

  buildPhase = "make";

  meta = with stdenv.lib; {
    homepage = https://suckless.org/;
    description = "Dynamic window manager for X, development version";
    license = licenses.mit;
    maintainers = with maintainers; [xeji];
    platforms = platforms.unix;
  };
}
