{
  stdenv,
  fetchurl,
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
}:

stdenv.mkDerivation rec {
  pname = "pstoedit";
  version = "4.02";

  src = fetchurl {
    url = "mirror://sourceforge/pstoedit/pstoedit-${version}.tar.gz";
    hash = "sha256-VYi0MtLGsq2YKLRJFepYE/+aOjMSpB+g3kw43ayd9y8=";
  };

  postPatch = ''
    # don't use gnu-isms like link.h on macos
    substituteInPlace src/pstoedit.cpp --replace-fail '#ifndef _MSC_VER' '#if !defined(_MSC_VER) && !defined(__APPLE__)'
  '';

  outputs = [
    "out"
    "dev"
  ];
  nativeBuildInputs = [
    makeWrapper
    pkg-config
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
    wrapProgram $out/bin/pstoedit \
      --prefix PATH : ${lib.makeBinPath [ ghostscript ]}
  '';

  meta = with lib; {
    description = "Translates PostScript and PDF graphics into other vector formats";
    homepage = "https://sourceforge.net/projects/pstoedit/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.unix;
    mainProgram = "pstoedit";
  };
}
