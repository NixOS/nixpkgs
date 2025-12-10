{
  lib,
  stdenv,
  fetchzip,
  callPackage,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "qbe";
  version = "1.2";

  src = fetchzip {
    url = "https://c9x.me/compile/release/qbe-${finalAttrs.version}.tar.xz";
    hash = "sha256-UgtJnZF/YtD54OBy9HzGRAEHx5tC9Wo2YcUidGwrv+s=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  doCheck = true;

  enableParallelBuilding = true;

  patches = [
    # Use "${TMPDIR:-/tmp}" instead of the latter directly
    # see <https://lists.sr.ht/~mpu/qbe/patches/49613>
    ./001-dont-hardcode-tmp.patch
  ];

  passthru = {
    tests.can-run-hello-world = callPackage ./test-can-run-hello-world.nix { };
  };

  meta = {
    homepage = "https://c9x.me/compile/";
    description = "Small compiler backend written in C";
    maintainers = with lib.maintainers; [ fgaz ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "qbe";
  };
})
