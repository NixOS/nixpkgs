{
  lib,
  stdenv,
  fetchzip,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "galleta";
  version = "20040505_1";

  src = fetchzip {
    url = "mirror://sourceforge/project/odessa/Galleta/${finalAttrs.version}/galleta_${finalAttrs.version}.zip";
    hash = "sha256-tc5XLToyQZutb51ZoBlGWXDpsSqdJ89bjzJwY8kRncA=";
  };

  patches = [
    # fix some GCC warnings.
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/galleta/-/raw/998470d8151b2f3a4bec71ae340c30f252d03a9b/debian/patches/10_fix-gcc-warnings.patch";
      hash = "sha256-b8VJGSAoSnWteyUbC2Ue3tqkpho7gyn+E/yrN2O3G9c=";
    })
    # make Makefile compliant with Debian and add GCC hardening.
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/galleta/-/raw/553c237a34995d9f7fc0383ee547d4f5cd004d5b/debian/patches/20_fix-makefile.patch";
      hash = "sha256-+rnoTrlXtWl9zmZlkvqbJ+YlIXFCpKOqvxIkN8xxtsg=";
    })
    # Fix cross compilation.
    # Galleta fails to cross build from source, because the upstream
    # Makefile hard codes the build architecture compiler. The patch
    # makes the compiler substitutable and galleta cross buildable.
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/galleta/-/raw/f0f51a5a9e5adc0279f78872461fa57ee90d6842/debian/patches/30-fix-FTBS-cross-compilation.patch";
      hash = "sha256-ZwymEVJy7KvLFvNOcVZqDtJPxEcpQBVg+u+G+kSDZBo=";
    })
  ];

  makeFlags = [
    "-C src"
    "CC=cc"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp src/galleta $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Examine the contents of the IE's cookie files for forensic purposes";
    mainProgram = "galleta";
    homepage = "https://sourceforge.net/projects/odessa/files/Galleta";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
})
