{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  texinfo,

  # for passthru.tests
  git,
  libguestfs,
  nixosTests,
  rpm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpio";
  version = "2.15";

  src = fetchurl {
    url = "mirror://gnu/cpio/cpio-${finalAttrs.version}.tar.bz2";
    hash = "sha256-k3YQuXwymh7JJoVT+3gAN7z/8Nz/6XJevE/ZwaqQdds=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2026-66484.patch";
      url = "https://git.savannah.gnu.org/cgit/cpio.git/patch/?id=e2b9cbdd3354d2b1569b7390d1bc15c1930559ad";
      hash = "sha256-WjphVpMaI/ePg8MTZx+vvilKzpRAAzhAFwCwrbsPLRE=";
    })
    (fetchpatch {
      name = "CVE-2026-66485.patch";
      url = "https://git.savannah.gnu.org/cgit/cpio.git/patch/?id=3cd514031371d8aeeaf2048aa10103e02831aaa9";
      hash = "sha256-YDlROEYYlZERNzzlx1cQD29gV5IrU01aVcZ/sKpWrRo=";
    })
    (fetchpatch {
      name = "CVE-2026-66486.patch";
      url = "https://git.savannah.gnu.org/cgit/cpio.git/patch/?id=2ff9600c9ef32e88759843cdbde74c8db5ae9b30";
      excludes = [ "NEWS" ];
      hash = "sha256-qi9/9xhKnIyPpji63RgzbnnHZsJgwRnQVMaMiLxQipk=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    texinfo # for makeinfo
  ];

  separateDebugInfo = true;

  # The code won't compile in c23 mode.
  # https://gcc.gnu.org/gcc-15/porting_to.html#c23-fn-decls-without-parameters
  configureFlags = [
    "CFLAGS=-std=gnu17"
  ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isCygwin ''
    sed -i gnu/fpending.h -e 's,include <stdio_ext.h>,,'
  '';

  enableParallelBuilding = true;

  passthru.tests = {
    inherit libguestfs rpm;
    git = git.tests.withInstallCheck;
    initrd = nixosTests.systemd-initrd-simple;
  };

  meta = {
    homepage = "https://www.gnu.org/software/cpio/";
    description = "Program to create or extract from cpio archives";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    priority = 6; # resolves collision with gnutar's "libexec/rmt"
    mainProgram = "cpio";
  };
})
