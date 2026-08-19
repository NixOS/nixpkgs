{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,

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

  nativeBuildInputs = [ autoreconfHook ];

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
