{ stdenv, lib, makeWrapper, fetchgit, pkgconfig, ninja, ocaml, findlib, mupdf
, lablgl, gtk3, openjpeg, jbig2dec, mujs, xsel, openssl, freetype, ncurses }:

assert lib.versionAtLeast (lib.getVersion ocaml) "4.02";

let ocamlVersion = (builtins.parseDrvName (ocaml.name)).version;
in stdenv.mkDerivation rec {
  name = "llpp-${version}";
  version = "26b";

  src = fetchgit {
    url = "git://repo.or.cz/llpp.git";
    rev = "v${version}";
    sha256 = "1w8g1fp1c20sl34cx20plhnbghbsx2fwgp4vyhd1x0za29lw62nj";
    fetchSubmodules = false;
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ninja ];
  buildInputs = [ ocaml findlib mupdf gtk3 jbig2dec openjpeg mujs openssl freetype ncurses ];

  dontStrip = true;

  configurePhase = ''
    sed -i -e 's+fz_set_use_document_css (state.ctx, usedoccss);+/* fz_set_use_document_css (state.ctx, usedoccss); */+' link.c
    sed -i -e 's+ocamlc --version+ocamlc -version+' build.sh
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
