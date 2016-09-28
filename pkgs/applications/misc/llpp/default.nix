{ stdenv, makeWrapper, fetchgit, pkgconfig, ninja, ocaml, findlib, mupdf, lablgl
, gtk3, openjpeg, jbig2dec, mujs, xsel, openssl, freetype, ncurses }:

let ocamlVersion = (builtins.parseDrvName (ocaml.name)).version;
in stdenv.mkDerivation rec {
  name = "llpp-${version}";
  version = "21-git-2016-05-07";

  src = fetchgit {
    url = "git://repo.or.cz/llpp.git";
    rev = "1beb003ca0f4ed90fda2823cb07c2eb674fc3ca4";
    sha256 = "1r59yfm81zmiij401d3wc3zb1zc873ss02gkplbwi4lad2l0chba";
    fetchSubmodules = false;
  };

  buildInputs = [ pkgconfig ninja makeWrapper ocaml findlib mupdf lablgl
                  gtk3 jbig2dec openjpeg mujs openssl freetype ncurses ];

  dontStrip = true;

  configurePhase = ''
    sed -i -e 's+-I \$srcdir/mupdf/include -I \$srcdir/mupdf/thirdparty/freetype/include+-I ${freetype.dev}/include+' build.sh
    sed -i -e 's+-lmupdf +-lfreetype -lz -lharfbuzz -ljbig2dec -lopenjp2 -ljpeg -lmupdf +' build.sh
    sed -i -e 's+-L\$srcdir/mupdf/build/native ++' build.sh
  '';

  buildPhase = ''
    sh ./build.sh build
  '';

  installPhase = ''
    install -d $out/bin $out/lib
    install build/llpp $out/bin
    wrapProgram $out/bin/llpp \
        --prefix CAML_LD_LIBRARY_PATH ":" "${lablgl}/lib/ocaml/${ocamlVersion}/site-lib/lablgl" \
        --prefix CAML_LD_LIBRARY_PATH ":" "$out/lib" \
        --prefix PATH ":" "${xsel}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = http://repo.or.cz/w/llpp.git;
    description = "A MuPDF based PDF pager written in OCaml";
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
    license = licenses.gpl3;
  };
}
