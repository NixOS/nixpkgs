{
  fetchFromSourcehut,
  gitUpdater,
  lib,
  qbe,
  stdenv,
}:
let
  platform = lib.toLower stdenv.hostPlatform.uname.system;
  arch = stdenv.hostPlatform.uname.processor;
  qbePlatform =
    {
      x86_64 = "amd64_sysv";
      aarch64 = "arm64";
      riscv64 = "rv64";
    }
    .${arch};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "harec";
  version = "0.24.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "harec";
    rev = finalAttrs.version;
    hash = "sha256-NOfoCT/wKZ3CXYzXZq7plXcun+MXQicfzBOmetXN7Qs=";
  };

  nativeBuildInputs = [ qbe ];

  buildInputs = [ qbe ];

  makeFlags = [
    "PREFIX=${builtins.placeholder "out"}"
    "ARCH=${arch}"
    "VERSION=${finalAttrs.version}-nixpkgs"
    "QBEFLAGS=-t${qbePlatform}"
    "CC=${stdenv.cc.targetPrefix}cc"
    "AS=${stdenv.cc.targetPrefix}as"
    "LD=${stdenv.cc.targetPrefix}ld"
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  doCheck = true;

  postConfigure = ''
    ln -s configs/${platform}.mk config.mk
  '';

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    homepage = "https://harelang.org/";
    description = "Bootstrapping Hare compiler written in C for POSIX systems";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ onemoresuza ];
    mainProgram = "harec";
    # The upstream developers do not like proprietary operating systems; see
    # https://harelang.org/platforms/
    # UPDATE: https://github.com/hshq/harelang provides a MacOS port
    platforms =
      with lib.platforms;
      lib.intersectLists (freebsd ++ openbsd ++ linux) (aarch64 ++ x86_64 ++ riscv64);
    badPlatforms = lib.platforms.darwin;
  };
})
