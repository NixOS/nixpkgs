{
  lib,
  stdenv,
  fetchzip,
  fetchpatch,
  pkg-config,
  boost,
  doxygen,
  icu,
  librevenge,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libmspub";
  version = "0.1.4";

  src = fetchzip {
    url = "https://dev-www.libreoffice.org/src/libmspub/libmspub-${finalAttrs.version}.tar.xz";
    hash = "sha256-/6e9IGcTIZTlnsakOaSjTn3DsO9ZNQigdCCbMbrBTQE=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    boost
    doxygen
    icu
    librevenge
    zlib
  ];

  configureFlags = [ "--with-docs" ];

  patches = [
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/libmspub/-/raw/main/buildfix.diff?ref_type=heads";
      hash = "sha256-evxEoQ0a6YHoymR+SEJwqfr7rkWp3JnsWOD1tfYfZOw=";
    })
  ];

  meta = {
    description = "Microsoft Publisher import library";
    homepage = "https://wiki.documentfoundation.org/DLP/Libraries/libmspub";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ arthsmn ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
  };
})
