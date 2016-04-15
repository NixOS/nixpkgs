{ stdenv, fetchFromGitHub, perl, libxcb, libXft }:

let
  version = "2015-07-23";
in
  stdenv.mkDerivation rec {
    name = "bar-xft-git-${version}";

    src = fetchFromGitHub {
      owner = "krypt-n";
      repo = "bar";
      rev = "3020df19232153f9e98ae0c8111db3de938a2719";
      sha256 = "0a54yr534jd4l5gjzpypc0y5lh2qb2wsrd662s84jjgq8bpss8av";
    };

    buildInputs = [ libxcb libXft perl ];

    prePatch = ''sed -i "s@/usr@$out@" Makefile'';

    meta = {
      description = "A lightweight xcb based bar with XFT-support";
      homepage = https://github.com/krypt-n/bar;
      maintainers = [ stdenv.lib.maintainers.hiberno ];
      license = "Custom";
      platforms = stdenv.lib.platforms.linux;
    };
}
