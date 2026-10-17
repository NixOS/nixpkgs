{
  lib,
  stdenv,
  fetchpatch2,
  linuxPackages,
}:

stdenv.mkDerivation {
  pname = "lkrg-logger";
  inherit (linuxPackages.lkrg) version src;

  sourceRoot = "source/logger";

  patches = [
    # Fix build with GCC 15
    (fetchpatch2 {
      name = "fix-build-with-gcc-15.patch";
      url = "https://github.com/lkrg-org/lkrg/commit/5689a8e949d9460a167419087c2ba629cae49b29.patch?full_index=1";
      relative = "logger";
      hash = "sha256-cthJEDmV9bIYIGEXrJR5J4gUxJRwJSYAVDwmVQFqtfE=";
    })
  ];

  strictDeps = true;
  __structuredAttrs = true;

  enableParallelBuilding = true;

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=${placeholder "out"}"
    "SBINDIR=${placeholder "out"}/bin"
  ];

  meta = {
    description = "Receiver and tools for the remote logging of the Linux Kernel Runtime Guard";
    homepage = "https://lkrg.org/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
    platforms = lib.platforms.linux;
    mainProgram = "lkrg-logger";
  };
}
