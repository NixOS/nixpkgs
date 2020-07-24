{ stdenv, lib, substituteAll, makeWrapper, fetchgit, ocaml, mupdf, libX11,
libGLU, libGL, freetype, xclip, inotify-tools, procps }:

assert lib.versionAtLeast (lib.getVersion ocaml) "4.07";

stdenv.mkDerivation rec {
  pname = "llpp";
  version = "32";

  src = fetchgit {
    url = "git://repo.or.cz/llpp.git";
    rev = "v${version}";
    sha256 = "1h1zysm5cz8laq8li49djl6929cnrjlflag9hw0c1dcr4zaxk32y";
    fetchSubmodules = false;
  };

  patches = (substituteAll {
    inherit version;
    src = ./fix-build-bash.patch;
  });

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ ocaml mupdf libX11 libGLU libGL freetype ];

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
    homepage = "https://repo.or.cz/w/llpp.git";
    description = "A MuPDF based PDF pager written in OCaml";
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub enzime ];
    license = licenses.gpl3;
  };
}
