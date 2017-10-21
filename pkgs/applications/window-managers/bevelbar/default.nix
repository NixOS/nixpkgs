{ stdenv, fetchFromGitHub, libX11, libXrandr, libXft }:

stdenv.mkDerivation rec {
  name = "bevelbar-${version}";
  version = "16.11";

  src = fetchFromGitHub {
    owner = "vain";
    repo = "bevelbar";
    rev = "v${version}";
    sha256 = "1hbwg3vdxw9fyshy85skv476p0zr4ynvhcz2xkijydpzm2j3rmjm";
  };

  buildInputs = [ libX11 libXrandr libXft ];

  installFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "An X11 status bar with fancy schmancy 1985-ish beveled borders";
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.neeasade ];
  };
}
