{ stdenv, fetchzip, asciidoc, sqlite, curl, pkgconfig, libxml2, stfl
, json-c-0-11 , ncurses , gettext, libiconv, makeWrapper, perl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "newsboat-${version}";
  version = "2.10.1";

  src = fetchzip {
    url = "https://newsboat.org/releases/${version}/${name}.tar.xz";
    sha256 = "019bm8j9vbpj39vs6xhrj34cd9ipjyqpwkl5psaks2w6g7wzyp1p";
  };

  buildInputs
    # use gettext instead of libintlOrEmpty so we have access to the msgfmt
    # command
    = [ asciidoc sqlite curl pkgconfig libxml2
      stfl json-c-0-11 ncurses gettext perl libiconv ]
      ++ stdenv.lib.optional stdenv.isDarwin makeWrapper;

  postPatch = ''
    substituteInPlace config.sh \
      --replace "ncurses5.4" "ncurses"
    substituteInPlace ./Makefile \
      --replace "a2x" "${asciidoc}/bin/a2x --no-xmllint"
  '';

  installFlags = [ "prefix=$(out)" ];

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    cp -r $src/contrib $out
    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix DYLD_LIBRARY_PATH : "${stfl}/lib"
    done
  '';

  meta = with stdenv.lib; {
    homepage    = http://www.newsboat.org;
    description = "An open-source RSS/Atom feed reader for text terminals";
    maintainers = with maintainers; [ nicknovitski ];
    license     = licenses.mit;
    platforms   = platforms.unix;
  };
}
