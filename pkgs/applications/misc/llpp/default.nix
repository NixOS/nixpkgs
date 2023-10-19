{ stdenv, lib, substituteAll, makeWrapper, fetchFromGitHub, fetchpatch, ocaml, pkg-config, mupdf, libX11, jbig2dec, openjpeg, libjpeg , lcms2, harfbuzz,
libGLU, libGL, gumbo, freetype, zlib, xclip, inotify-tools, procps }:

assert lib.versionAtLeast (lib.getVersion ocaml) "4.07";

stdenv.mkDerivation rec {
  pname = "llpp";
  version = "41";

  src = fetchFromGitHub {
    owner = "criticic";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Doj0zLYI1pi7eK01+29xFLYPtc8+fWzj10292+PmToE=";
  };

  patches = [
    (fetchpatch {
      name = "system-makedeps.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/system-makedeps.patch?h=llpp&id=0d2913056aaf3dbf7431e57b7b08b55568ba076c";
      hash = "sha256-t9PLXsM8+exCeYqJBe0LSDK0D2rpktmozS8qNcEAcHo=";
    })
    ./fix-mupdf.patch
  ];

  postPatch = ''
    sed -i "2d;s/ver=.*/ver=${version}/" build.bash
  '';

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ocaml pkg-config ];
  buildInputs = [ mupdf libX11 libGLU libGL freetype zlib gumbo jbig2dec openjpeg libjpeg lcms2 harfbuzz ];

  dontStrip = true;

  configurePhase = ''
    mkdir -p build/mupdf/thirdparty
    ln -s ${freetype.dev} build/mupdf/thirdparty/freetype
  '';

  buildPhase = ''
    bash ./build.bash build
  '';

  installPhase = ''
    install -d $out/bin
    install build/llpp $out/bin
    install misc/llpp.inotify $out/bin/llpp.inotify

    wrapProgram $out/bin/llpp \
        --prefix PATH ":" "${xclip}/bin"

    wrapProgram $out/bin/llpp.inotify \
        --prefix PATH ":" "$out/bin" \
        --prefix PATH ":" "${inotify-tools}/bin" \
        --prefix PATH ":" "${procps}/bin"
  '';

  meta = with lib; {
    homepage = "https://repo.or.cz/w/llpp.git";
    description = "A MuPDF based PDF pager written in OCaml";
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
    license = licenses.gpl3;
  };
}
