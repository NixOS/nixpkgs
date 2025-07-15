{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  doctest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "foonathan-memory";
  version = "0.7-4";

  src = fetchFromGitHub {
    owner = "foonathan";
    repo = "memory";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qGbI7SL6lDbJzn2hkqaYw35QAyvSPxcZTb0ltDkPUSo=";
  };

  patches = [
    # do not download doctest, use the system doctest instead
    # originally from: https://sources.debian.org/data/main/f/foonathan-memory/0.7.3-2/debian/patches/0001-Use-system-doctest.patch
    ./0001-Use-system-doctest.patch.patch
  ];

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    (lib.cmakeBool "FOONATHAN_MEMORY_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  checkInputs = [ doctest ];

  # fix a circular dependency between "out" and "dev" outputs
  postInstall = ''
    mkdir -p $out/lib/cmake
    mv $out/lib/foonathan_memory/cmake $out/lib/cmake/foonathan_memory
    rmdir $out/lib/foonathan_memory
  '';

  meta = with lib; {
    homepage = "https://memory.foonathan.net/";
    changelog = "https://github.com/foonathan/memory/releases/tag/${finalAttrs.src.rev}";
    description = "STL compatible C++ memory allocator library";
    mainProgram = "nodesize_dbg";

    longDescription = ''
      The C++ STL allocator model has various flaws. For example, they are
      fixed to a certain type, because they are almost necessarily required to
      be templates. So you can't easily share a single allocator for multiple
      types. In addition, you can only get a copy from the containers and not
      the original allocator object. At least with C++11 they are allowed to be
      stateful and so can be made object not instance based. But still, the
      model has many flaws. Over the course of the years many solutions have
      been proposed, for example EASTL. This library is another. But instead of
      trying to change the STL, it works with the current implementation.
    '';

    license = licenses.zlib;
    maintainers = with maintainers; [ panicgh ];
    platforms = with platforms; unix ++ windows;
  };
})
