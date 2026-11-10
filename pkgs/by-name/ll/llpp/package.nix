{
  stdenv,
  lib,
  makeWrapper,
  fetchFromGitHub,
  ocaml,
  pkg-config,
  mupdf,
  libx11,
  jbig2dec,
  openjpeg,
  libjpeg,
  lcms2,
  harfbuzz,
  libGLU,
  libGL,
  gumbo,
  freetype,
  zlib,
  xclip,
  inotify-tools,
  procps,
}:

assert lib.versionAtLeast (lib.getVersion ocaml) "4.07";

stdenv.mkDerivation (finalAttrs: {
  pname = "llpp";
  version = "42";

  src = fetchFromGitHub {
    owner = "criticic";
    repo = "llpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-B/jKvBtBwMOErUVmGFGXXIT8FzMl1DFidfDCHIH41TU=";
  };

  patches = [
    # Compatibility with mupdf 1.26
    ./mupdf-1.26.patch
  ];

  postPatch = ''
    sed -i "2d;s/ver=.*/ver=${finalAttrs.version}/" build.bash
  '';

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    ocaml
    pkg-config
  ];
  buildInputs = [
    mupdf
    libx11
    freetype
    zlib
    gumbo
    jbig2dec
    openjpeg
    libjpeg
    lcms2
    harfbuzz
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGLU
    libGL
  ];

  dontStrip = true;

  buildPhase = ''
    bash ./build.bash build
  '';

  installPhase = ''
    install -d $out/bin
    install build/llpp $out/bin
    install misc/llpp.inotify $out/bin/llpp.inotify
    install -Dm444 misc/llpp.desktop -t $out/share/applications
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/llpp \
        --prefix PATH ":" "${xclip}/bin"

    wrapProgram $out/bin/llpp.inotify \
        --prefix PATH ":" "$out/bin" \
        --prefix PATH ":" "${inotify-tools}/bin" \
        --prefix PATH ":" "${procps}/bin"
  '';

  meta = {
    homepage = "https://github.com/criticic/llpp";
    description = "MuPDF based PDF pager written in OCaml";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ pSub ];
    license = [
      lib.licenses.publicDomain
      lib.licenses.bsd3
    ];
  };
})
