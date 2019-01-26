{ stdenv, lib, substituteAll, makeWrapper, fetchgit, ocaml, mupdf, libX11,
libGLU_combined, freetype, xclip }:

assert lib.versionAtLeast (lib.getVersion ocaml) "4.07";

stdenv.mkDerivation rec {
  name = "llpp-${version}";
  version = "30";

  src = fetchgit {
    url = "git://repo.or.cz/llpp.git";
    rev = "v${version}";
    sha256 = "0iilpzf12hs0zky58j55l4y5dvzv7fc53nsrg324n9vka92mppvd";
    fetchSubmodules = false;
  };

  patches = (substituteAll {
    inherit version;
    src = ./fix-build-bash.patch;
  });

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ ocaml mupdf libX11 libGLU_combined freetype ];

  dontStrip = true;

  configurePhase = ''
    mkdir -p build/mupdf/thirdparty
    ln -s ${freetype.dev} build/mupdf/thirdparty/freetype
  '';

  buildPhase = ''
    bash ./build.bash build
  '';

  installPhase = ''
    install -d $out/bin $out/lib
    install build/llpp $out/bin
    wrapProgram $out/bin/llpp \
        --prefix CAML_LD_LIBRARY_PATH ":" "$out/lib" \
        --prefix PATH ":" "${xclip}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = https://repo.or.cz/w/llpp.git;
    description = "A MuPDF based PDF pager written in OCaml";
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub enzime ];
    license = licenses.gpl3;
  };
}
