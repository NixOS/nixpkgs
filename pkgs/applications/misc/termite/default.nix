{ stdenv, fetchgit, pkgconfig, vte, gtk3, ncurses }:

stdenv.mkDerivation rec {
  name = "termite-${version}";
  version = "11";

  src = fetchgit {
    url = "https://github.com/thestinger/termite";
    rev = "refs/tags/v${version}";
    sha256 = "1k91nw19c0p5ghqhs00mn9npa91idfkyiwik3ng6hb4jbnblp5ph";
  };

  makeFlags = [ "VERSION=v${version}" "PREFIX=" "DESTDIR=$(out)" ];

  buildInputs = [ pkgconfig vte gtk3 ncurses ];

  outputs = [ "out" "terminfo" ];

  postInstall = ''
    mkdir -p $terminfo/share
    mv $out/share/terminfo $terminfo/share/terminfo

    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  meta = with stdenv.lib; {
    description = "A simple VTE-based terminal";
    license = licenses.lgpl2Plus;
    homepage = https://github.com/thestinger/termite/;
    maintainers = [ maintainers.koral ];
    platforms = platforms.all;
  };
}
