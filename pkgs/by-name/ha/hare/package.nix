{
  lib,
  stdenv,
  fetchFromSourcehut,
  harec,
  qbe,
  gitUpdater,
  scdoc,
  tzdata,
  mailcap,
  substituteAll,
  fetchpatch,
  callPackage,
  enableCrossCompilation ? (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.is64bit),
  pkgsCross,
  x86_64PkgsCrossToolchain ? pkgsCross.gnu64,
  aarch64PkgsCrossToolchain ? pkgsCross.aarch64-multiplatform,
  riscv64PkgsCrossToolchain ? pkgsCross.riscv64,
}:

# There's no support for `aarch64` or `riscv64` for freebsd nor for openbsd on nix.
# See `lib.systems.doubles.aarch64` and `lib.systems.doubles.riscv64`.
assert
  let
    inherit (stdenv.hostPlatform) isLinux is64bit;
    inherit (lib) intersectLists platforms concatStringsSep;
    workingPlatforms = intersectLists platforms.linux (with platforms; x86_64 ++ aarch64 ++ riscv64);
  in
  (enableCrossCompilation -> !(isLinux && is64bit))
  -> builtins.throw ''
    The cross-compilation toolchains may only be enabled on the following platforms:
    ${concatStringsSep "\n" workingPlatforms}
  '';

let
  buildArch = stdenv.buildPlatform.uname.processor;
  arch = stdenv.hostPlatform.uname.processor;
  platform = lib.toLower stdenv.hostPlatform.uname.system;
  qbePlatform =
    {
      x86_64 = "amd64_sysv";
      aarch64 = "arm64";
      riscv64 = "rv64";
    }
    .${arch};
  embeddedOnBinaryTools =
    let
      genPaths =
        toolchain:
        let
          inherit (toolchain.stdenv.cc) targetPrefix;
          inherit (toolchain.stdenv.targetPlatform.uname) processor;
        in
        {
          "${processor}" = {
            "ld" = lib.getExe' toolchain.buildPackages.binutils "${targetPrefix}ld";
            "as" = lib.getExe' toolchain.buildPackages.binutils "${targetPrefix}as";
            "cc" = lib.getExe' toolchain.stdenv.cc "${targetPrefix}cc";
          };
        };
    in
    builtins.foldl' (acc: elem: acc // (genPaths elem)) { } [
      x86_64PkgsCrossToolchain
      aarch64PkgsCrossToolchain
      riscv64PkgsCrossToolchain
    ];
  crossCompMakeFlags = builtins.filter (x: !(lib.hasPrefix (lib.toUpper buildArch) x)) [
    "RISCV64_AS=${embeddedOnBinaryTools.riscv64.as}"
    "RISCV64_CC=${embeddedOnBinaryTools.riscv64.cc}"
    "RISCV64_LD=${embeddedOnBinaryTools.riscv64.ld}"
    "AARCH64_AS=${embeddedOnBinaryTools.aarch64.as}"
    "AARCH64_CC=${embeddedOnBinaryTools.aarch64.cc}"
    "AARCH64_LD=${embeddedOnBinaryTools.aarch64.ld}"
    "X86_64_AS=${embeddedOnBinaryTools.x86_64.as}"
    "X86_64_CC=${embeddedOnBinaryTools.x86_64.cc}"
    "X86_64_LD=${embeddedOnBinaryTools.x86_64.ld}"
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hare";
  version = "0.24.0";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare";
    rev = finalAttrs.version;
    hash = "sha256-3T+BdNj+Th8QXrcsPMWlN9GBfuMF1ulneWHpDEtyBU8=";
  };

  patches = [
    # Replace FHS paths with nix store
    (substituteAll {
      src = ./001-tzdata.patch;
      inherit tzdata;
    })
    # Use correct comment syntax for debug+riscv64.
    (fetchpatch {
      url = "https://git.sr.ht/~sircmpwn/hare/commit/80e45e4d931a6e90d999846b86471cac00d2a6d5.patch";
      hash = "sha256-S7nXpiO0tYnKpmpj+fLkolGeHb1TrmgKlMF0+j0qLPQ=";
    })
    # Don't build haredoc since it uses the build `hare` bin, which breaks
    # cross-compilation.
    ./002-dont-build-haredoc.patch
    # Hardcode harec and qbe.
    (substituteAll {
      src = ./003-hardcode-qbe-and-harec.patch;
      harec = lib.getExe harec;
      qbe = lib.getExe qbe;
    })
    # Display toolchains when using `hare version -v`.
    (fetchpatch {
      url = "https://git.sr.ht/~sircmpwn/hare/commit/e35f2284774436f422e06f0e8d290b173ced1677.patch";
      hash = "sha256-A59bGO/9tOghV8/MomTxd8xRExkHVdoMom2d+HTfQGg=";
    })
    # Use mailcap `/etc/mime.types` for Hare's mime module
    (substituteAll {
      src = ./003-use-mailcap-for-mimetypes.patch;
      inherit mailcap;
    })
  ];

  nativeBuildInputs = [
    harec
    qbe
    scdoc
  ];

  # Needed for build frameworks like `haredo`, which set the HAREC and QBE env vars to `harec` and
  # `qbe` respectively.
  propagatedBuildInputs = [
    harec
    qbe
  ];

  buildInputs = [
    harec
    qbe
  ];

  makeFlags = [
    "HARECACHE=.harecache"
    "PREFIX=${builtins.placeholder "out"}"
    "ARCH=${arch}"
    "VERSION=${finalAttrs.version}-nixpkgs"
    "QBEFLAGS=-t${qbePlatform}"
    "AS=${stdenv.cc.targetPrefix}as"
    "LD=${stdenv.cc.targetPrefix}ld"
    "${lib.toUpper buildArch}_AS=${embeddedOnBinaryTools.${buildArch}.as}"
    "${lib.toUpper buildArch}_CC=${embeddedOnBinaryTools.${buildArch}.cc}"
    "${lib.toUpper buildArch}_LD=${embeddedOnBinaryTools.${buildArch}.ld}"
    # Strip the variable of an empty $(SRCDIR)/hare/third-party, since nix does
    # not follow the FHS.
    "HAREPATH=$(SRCDIR)/hare/stdlib"
  ] ++ lib.optionals enableCrossCompilation crossCompMakeFlags;

  enableParallelBuilding = true;

  # Append the distribution name to the version
  env.LOCALVER = "nixpkgs";

  strictDeps = true;

  doCheck = true;

  postConfigure = ''
    ln -s configs/${platform}.mk config.mk
  '';

  setupHook = ./setup-hook.sh;

  passthru = {
    updateScript = gitUpdater { };
    tests =
      lib.optionalAttrs enableCrossCompilation {
        crossCompilation = callPackage ./cross-compilation-tests.nix { hare = finalAttrs.finalPackage; };
      }
      // lib.optionalAttrs (stdenv.buildPlatform.canExecute stdenv.hostPlatform) {
        mimeModule = callPackage ./mime-module-test.nix { hare = finalAttrs.finalPackage; };
      };
  };

  meta = {
    homepage = "https://harelang.org/";
    description = "Systems programming language designed to be simple, stable, and robust";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ onemoresuza ];
    mainProgram = "hare";
    inherit (harec.meta) platforms badPlatforms;
  };
})
