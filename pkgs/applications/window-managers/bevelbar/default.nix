{ stdenv, fetchurl, libX11, libXrandr, libXft }:

stdenv.mkDerivation rec {
  name = "${repo}-${version}";
  version = "16.11";
  repo = "bevelbar";
  repoOwner = "vain";

  src = fetchurl {
    url = "https://github.com/${repoOwner}/${repo}/archive/v${version}.tar.gz";
    sha256 = "0pxj54qkw2nsci6x36my47n555d23618h8gzmim4djdyw1yybd0n";
  };

  buildInputs = [ libX11 libXrandr libXft ];

  makeFlags = [ "prefix=$(out)" ];
  installFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "An X11 status bar with fancy schmancy 1985-ish beveled borders";
    homepage = "https://github.com/${repoOwner}/${repo}";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.neeasade ];
  };
}
