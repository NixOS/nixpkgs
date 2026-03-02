{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  perl,
  pkg-config,
  netsurf-buildsystem,
  libparserutils,
  libwapcaplet,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcss";
  version = "0.9.2";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libcss-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-LfIVu+w01R1gwaBLAbLfTV0Y9RDx86evS4DN21ZxFU4=";
  };

  patches = [
    # select: computed: Squash -Wcalloc-transposed-args (gcc-14)
    # remove on next release
    (fetchpatch {
      name = "fix-calloc-transposed-args-computed.patch";
      url = "https://source.netsurf-browser.org/libcss.git/patch/?id=0541e18b442d2f46abc0f0b09e0db950e1b657e5";
      hash = "sha256-6nrT1S1E+jU6UDr3BZo9GH8jcSiIwTNLnmI1rthhhws=";
    })
    # select: select: Squash -Wcalloc-transposed-args (gcc-14)
    # remove on next release
    (fetchpatch {
      name = "fix-calloc-transposed-args-select.patch";
      url = "https://source.netsurf-browser.org/libcss.git/patch/?id=8619d09102d6cc34d63fe87195c548852fc93bf4";
      hash = "sha256-Clkhw/n/+NQR/T8Gi+2Lc1Neq5dWsNKM8RqieYuTnzQ=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    perl
    netsurf-buildsystem
    libparserutils
    libwapcaplet
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${netsurf-buildsystem}/share/netsurf-buildsystem"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=implicit-fallthrough"
    "-Wno-error=${if stdenv.cc.isGNU then "maybe-uninitialized" else "uninitialized"}"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libcss/";
    description = "Cascading Style Sheets library for netsurf browser";
    longDescription = ''
      LibCSS is a CSS parser and selection engine. It aims to parse the forward
      compatible CSS grammar. It was developed as part of the NetSurf project
      and is available for use by other software, under a more permissive
      license.
    '';
    license = lib.licenses.mit;
    inherit (netsurf-buildsystem.meta) maintainers platforms;
  };
})
