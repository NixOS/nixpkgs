{ stdenv, lib, substituteAll, makeWrapper, fetchFromGitHub, fetchpatch, ocaml, pkg-config, mupdf, libX11, jbig2dec, openjpeg, libjpeg , lcms2, harfbuzz,
libGLU, libGL, gumbo, freetype, zlib, xclip, inotify-tools, procps, darwin }:

assert lib.versionAtLeast (lib.getVersion ocaml) "4.07";

stdenv.mkDerivation rec {
  pname = "llpp";
  version = "42";

  src = fetchFromGitHub {
    owner = "criticic";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-B/jKvBtBwMOErUVmGFGXXIT8FzMl1DFidfDCHIH41TU=";
  };

  postPatch = ''
    sed -i "2d;s/ver=.*/ver=${version}/" build.bash
  '';

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ocaml pkg-config ];
  buildInputs = [ mupdf libX11 freetype zlib gumbo jbig2dec openjpeg libjpeg lcms2 harfbuzz ]
    ++ lib.optionals stdenv.isLinux [ libGLU libGL ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.OpenGL darwin.apple_sdk.frameworks.Cocoa ];

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
  '' + lib.optionalString stdenv.isLinux ''
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
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ pSub ];
    license = licenses.gpl3;
  };
}
