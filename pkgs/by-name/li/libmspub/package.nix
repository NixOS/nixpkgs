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

  # configure.ac:107 does `PKG_CHECK_MODULES([ICU], [icu-i18n])`. The
  # pkg-config file `icu-i18n.pc` declares `Requires.private: icu-uc`,
  # so `pkg-config --libs icu-i18n` returns only `-licui18n` — fine on
  # linux where the linker auto-pulls libicuuc via NEEDED-entry chain,
  # but darwin's two-level namespace doesn't follow indirect dylib
  # deps, so symbols defined in libicuuc (ucnv_open, uloc_getCountry,
  # …) end up unresolved at link. Force ICU_LIBS to include icu-uc
  # explicitly. Setting it in the env before configure runs makes
  # PKG_CHECK_MODULES skip its own detection (per autoconf docs).
  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export ICU_LIBS="-licui18n -licuuc -licudata"
    export ICU_CFLAGS="-I${lib.getDev icu}/include"
  '';

  patches = [
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/libmspub/-/raw/8721a52e09e14f905311abd3d5f2ad9bb3fe78a2/buildfix.diff";
      hash = "sha256-evxEoQ0a6YHoymR+SEJwqfr7rkWp3JnsWOD1tfYfZOw=";
    })
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/libmspub/-/raw/9d565015753364fa458da19e5dd4ce8224cf9246/includes.patch";
      hash = "sha256-oHXEWSOSod9VnOrFtdMQcHYm7EdKkG+S7Q9rfM0DaTg=";
    })
  ];

  meta = {
    description = "Microsoft Publisher import library";
    homepage = "https://wiki.documentfoundation.org/DLP/Libraries/libmspub";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
  };
})
