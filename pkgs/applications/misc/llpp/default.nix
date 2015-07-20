{ stdenv, makeWrapper, fetchgit, pkgconfig, ninja, ocaml, findlib, mupdf, lablgl
, gtk3, openjpeg, jbig2dec, mujs, xsel }:

let ocamlVersion = (builtins.parseDrvName (ocaml.name)).version;
in stdenv.mkDerivation rec {
  name = "llpp-${version}";
  version = "21-git-2015-06-27";

  src = fetchgit {
    url = "git://repo.or.cz/llpp.git";
    rev = "843c42ef41bb78a3b1ee995fc2bab91f8796e8ad";
    sha256 = "0h8wa7f5bj5sm3sr8namcyy81s4s80hyasimyfw935lqyw2q2k60";
  };

  buildInputs = [ pkgconfig ninja makeWrapper ocaml findlib mupdf lablgl
                  gtk3 jbig2dec openjpeg mujs ];

  configurePhase = ''
      sh configure.sh -O -F ${mupdf}
      sed -i 's;-lopenjpeg;-lopenjp2;g' .config
      sed -i 's;$builddir/link\.so;link.so;g' build.ninja
  '';

  buildPhase = "${ninja}/bin/ninja";

  installPhase = ''
    install -d $out/bin $out/lib
    install build/llpp $out/bin
    install link.so $out/lib
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
