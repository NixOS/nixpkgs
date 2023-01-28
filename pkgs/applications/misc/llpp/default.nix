{ stdenv, lib, substituteAll, makeWrapper, fetchgit, ocaml, mupdf, libX11, jbig2dec, openjpeg, libjpeg , lcms2, harfbuzz,
libGLU, libGL, gumbo, freetype, zlib, xclip, inotify-tools, procps }:

assert lib.versionAtLeast (lib.getVersion ocaml) "4.07";

stdenv.mkDerivation rec {
  pname = "llpp";
  version = "33";

  src = fetchgit {
    url = "git://repo.or.cz/llpp.git";
    rev = "v${version}";
    sha256 = "0shqzhaflm2yhkx6c0csq9lxp1s1r7lh5kgpx9q5k06xya2a7yvs";
    fetchSubmodules = false;
  };

  patches = (substituteAll {
    inherit version;
    src = ./fix-build-bash.patch;
  });

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ ocaml mupdf libX11 libGLU libGL freetype zlib gumbo jbig2dec openjpeg libjpeg lcms2 harfbuzz ];

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
    # Project is unmaintained and fails to build:
    # link.c:987:27: error: invalid operands to binary >= (have 'fz_location' and 'int')
    broken = true;
    maintainers = with maintainers; [ pSub ];
    license = licenses.gpl3;
  };
}
