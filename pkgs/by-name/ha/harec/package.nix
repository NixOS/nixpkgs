{
  _experimental-update-script-combinators,
  fetchFromSourcehut,
  gitUpdater,
  lib,
  qbe,
  stdenv,
  fetchpatch,
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
  version = "0.25.2";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "harec";
    rev = finalAttrs.version;
    hash = "sha256-5+aYoO7khH1wfH0iC6ZiIVZ4Y11+TpIC4yaEEEC00GM=";
  };

  patches = [
    # Fix miscellaneous gcc warnings
    (fetchpatch {
      url = "https://git.sr.ht/~sircmpwn/harec/commit/31df27c26e026f3d934759f0e7b3ff105e7bf74c.patch";
      hash = "sha256-in1MQjiNovlebGaykE8/aMEJkz+bRtlr5EYvCXW4jSA=";
    })
  ];

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
    updateScript = _experimental-update-script-combinators.sequence (
      builtins.map (item: item.command) [
        (gitUpdater {
          attrPath = "harec";
          ignoredVersions = [ "-rc[0-9]{1,}" ];
        })
        (gitUpdater {
          attrPath = "hare";
          url = "https://git.sr.ht/~sircmpwn/hare";
          ignoredVersions = [ "-rc[0-9]{1,}" ];
        })
      ]
    );
    # To be kept in sync with the hare package.
    inherit qbe;
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
