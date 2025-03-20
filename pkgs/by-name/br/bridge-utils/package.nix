{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "bridge-utils";
  version = "1.7.1";

  src = fetchurl {
    url = "https://kernel.org/pub/linux/utils/net/bridge-utils/bridge-utils-${version}.tar.xz";
    sha256 = "sha256-ph2L5PGhQFxgyO841UTwwYwFszubB+W0sxAzU2Fl5g4=";
  };

  patches = [
    ./autoconf-ar.patch

    (fetchpatch {
      name = "musl-includes.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/bridge-utils/fix-PATH_MAX-on-ppc64le.patch?id=12c9046eee3a0a35665dc4e280c1f5ae2af5845d";
      sha256 = "sha256-uY1tgJhcm1DFctg9scmC8e+mgowgz4f/oF0+k+x+jqw=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Userspace tool to configure linux bridges (deprecated in favour or iproute2)";
    mainProgram = "brctl";
    homepage = "https://wiki.linuxfoundation.org/networking/bridge";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
