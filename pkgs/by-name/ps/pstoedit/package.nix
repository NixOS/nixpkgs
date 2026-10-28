{
  stdenv,
  fetchFromGitHub,
  pkg-config,
  lib,
  zlib,
  ghostscript,
  imagemagick,
  plotutils,
  gd,
  libjpeg,
  libwebp,
  libiconv,
  makeWrapper,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pstoedit";
  version = "4.3";

  src = fetchFromGitHub {
    owner = "woglu";
    repo = "pstoedit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wodTvVbsouSjH5JDJ2ELlq5p7HRfNwN457gb6tRAkBg=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    autoreconfHook
  ];

  env.LANG = "C";

  # https://github.com/woglu/pstoedit/issues/7
  preConfigure = ''
    touch doc/pstoedit.1 doc/pstoedit.pdf doc/pstoedit.htm
  '';

  # https://github.com/woglu/pstoedit/blob/v4.3/.github/workflows/c-cpp.yml#L21
  appendConfigureFlags = [
    "--disable-check_for_gs"
    "--enable-docs=no"
  ];

  buildInputs = [
    zlib
    ghostscript
    imagemagick
    plotutils
    gd
    libjpeg
    libwebp
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  postInstall = ''
    make clean
    sh rm_generated.sh
    wrapProgram $out/bin/pstoedit \
      --prefix PATH : ${lib.makeBinPath [ ghostscript ]}
  '';

  meta = {
    description = "Translates PostScript and PDF graphics into other vector formats";
    homepage = "https://github.com/woglu/pstoedit";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "pstoedit";
  };
})
