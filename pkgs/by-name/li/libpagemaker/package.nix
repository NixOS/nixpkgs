{
  lib,
  stdenv,
  fetchzip,
  fetchpatch,
  pkg-config,
  boost,
  doxygen,
  librevenge,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libpagemaker";
  version = "0.0.4";

  src = fetchzip {
    url = "https://dev-www.libreoffice.org/src/libpagemaker/libpagemaker-${finalAttrs.version}.tar.xz";
    hash = "sha256-fAtCNbP0fI2LxTOPPh5zbdF50wWhsrfSoNFPVU9tBas=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    boost
    doxygen
    librevenge
  ];

  patches = [
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/libpagemaker/-/raw/main/libpagemaker-0.0.4-const-ref-exception.patch?ref_type=heads";
      hash = "sha256-yZbiLAZHgzygGetiuoKiQS010pRfZTi2CbAAxQdCZbs=";
    })
  ];

  meta = {
    description = "Adobe PageMaker import library";
    homepage = "https://wiki.documentfoundation.org/DLP/Libraries/libpagemaker";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ arthsmn ];
    platforms = lib.platforms.all;
  };
})
