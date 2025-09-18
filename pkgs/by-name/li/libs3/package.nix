{
  curl,
  fetchFromGitHub,
  fetchpatch,
  lib,
  libxml2,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "libs3";
  version = "0-unstable-2019-04-10";

  src = fetchFromGitHub {
    owner = "bji";
    repo = "libs3";
    rev = "287e4bee6fd430ffb52604049de80a27a77ff6b4";
    hash = "sha256-xgiY8oJlRMiXB1fw5dhNidfaq18YVwaJ8aErKU11O6U=";
  };

  patches = [
    (fetchpatch {
      # Fix compilation with openssl 3.0
      url = "https://github.com/bji/libs3/pull/112/commits/3c3a1cf915e62b730db854d8007ba835cb38677c.patch";
      hash = "sha256-+rWRh8dOznHlamc/T9qbgN0E2Rww3Hn94UeErxNDccs=";
    })
    (fetchpatch {
      # Fix compilation with new curl
      url = "https://github.com/bji/libs3/pull/115/commits/01c8c216128f49936ee3fcf7b66905f8813ea0bd.diff";
      hash = "sha256-/8lv+Mi9XtEVlZV/sypp4AY4Wxd7XmKt3S6Q7KCxw6I=";
    })
  ];

  postPatch = ''
    substituteInPlace GNUmakefile \
      --replace-fail curl-config "$PKG_CONFIG libcurl" \
      --replace-fail xml2-config "$PKG_CONFIG libxml-2.0"
  '';

  makeFlags = [ "DESTDIR=${placeholder "out"}" ];

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    curl
    libxml2
  ];

  meta = {
    description = "Library for interfacing with amazon s3";
    homepage = "https://github.com/bji/libs3";
    license = lib.licenses.lgpl3Plus;
    mainProgram = "s3";
    platforms = lib.platforms.linux;
  };
}
