{
  lib,
  fetchFromGitHub,
  stdenv,

  autoreconfHook,
  gtest,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "memtailor";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "Macaulay2";
    repo = "memtailor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-efFsGy0ezQrNHWn7VX1hNJ7oln+aLu/JFjUEtyakEyY=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  checkInputs = [
    gtest
  ];

  __structuredAttrs = true;

  strictDeps = true;

  configureFlags = [
    (lib.withFeature finalAttrs.finalPackage.doCheck "gtest")
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "C++ library of special purpose memory allocators";
    longDescription = ''
      Memtailor is a C++ library of special purpose memory allocators. It
      currently offers an arena allocator and a memory pool.

      The main motivation to use a memtailor allocator is better and more
      predictable performance than you get with new/delete. Sometimes a
      memtailor allocator can also be more convenient due to the ability to
      free many allocations at one time.
    '';
    homepage = "https://github.com/Macaulay2/memtailor";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ coolcuber ];
    platforms = lib.platforms.unix;
  };
})
