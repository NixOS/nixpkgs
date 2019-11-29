{ stdenv, lib, substituteAll, makeWrapper, fetchgit, ocaml, mupdf, libX11,
libGLU_combined, freetype, xclip, inotify-tools, procps }:

assert lib.versionAtLeast (lib.getVersion ocaml) "4.07";

stdenv.mkDerivation rec {
  pname = "llpp";
  version = "31";

  src = fetchgit {
    url = "git://repo.or.cz/llpp.git";
    rev = "v${version}";
    sha256 = "14ibsm1zzxfidjajcj30b5m9in10q3817izahsjvkmryrvvn6qsg";
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

  meta = with stdenv.lib; {
    homepage = https://repo.or.cz/w/llpp.git;
    description = "A MuPDF based PDF pager written in OCaml";
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub enzime ];
    license = licenses.gpl3;
  };
}
