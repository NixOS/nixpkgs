{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  pkg-config,
  fribidi,
  libunibreak,
  freetype,
  fontconfig,
  harfbuzz,
  zlib,
  zstd,
  libpng,
  libjpeg,
  utf8proc,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "crengine-ng";
<<<<<<< HEAD
  version = "0.9.13";
=======
  version = "0.9.12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    owner = "coolreader-ng";
    repo = "crengine-ng";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-0/exAqEs//tUlGpiBqeKkZ4LJeY7u0W4j4V9G5lL5cg=";
=======
    hash = "sha256-sNExFNnUKfl+4VCWeqK/Pt2Qy6DtYn7GYnwz5hHkjZw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fribidi
    libunibreak
    freetype
    fontconfig
    harfbuzz
    zlib
    zstd
    libpng
    libjpeg
    utf8proc
  ];

  postPatch = ''
    substituteInPlace crengine/crengine-ng.pc.cmake \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = {
    homepage = "https://gitlab.com/coolreader-ng/crengine-ng";
    description = "Cross-platform library designed to implement text viewers and e-book readers";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ vnpower ];
  };
})
