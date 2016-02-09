{ stdenv, fetchFromGitHub, perl, libxcb }:

let
  version = "1.2pre";
in
  stdenv.mkDerivation rec {
    name = "lemonbar-${version}";
  
    src = fetchFromGitHub {
      owner = "LemonBoy";
      repo = "bar";
      rev = "61985278f2af1e4e85d63a696ffedc5616b06bc0";
      sha256 = "0a8djlayimjdg5fj50lpifsv6gkb577bca68wmk9wg9y9n27pgay";
    };
  
    buildInputs = [ libxcb perl ];
  
    prePatch = ''sed -i "s@/usr@$out@" Makefile'';
  
    meta = with stdenv.lib; {
      description = "A lightweight xcb based bar";
      homepage = https://github.com/LemonBoy/bar;
      maintainers = [ maintainers.meisternu ];
      license = "Custom";   
      platforms = platforms.linux;
    };
}
