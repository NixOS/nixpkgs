{
  lib,
  stdenv,
  fetchFromSourcehut,
  binutils-unwrapped,
  harec,
  makeWrapper,
  qbe,
  gitUpdater,
  scdoc,
  tzdata,
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
  arch = stdenv.hostPlatform.uname.processor;
  qbePlatform =
    {
      x86_64 = "amd64_sysv";
      aarch64 = "arm64";
      riscv64 = "rv64";
    }
    .${arch};
  platform = lib.toLower stdenv.hostPlatform.uname.system;
  embeddedOnBinaryTools =
    let
      genToolsFromToolchain =
        toolchain:
        let
          crossTargetPrefix = toolchain.stdenv.cc.targetPrefix;
          toolchainArch = toolchain.stdenv.hostPlatform.uname.processor;
          absOrRelPath =
            toolDrv: toolBasename:
            if arch == toolchainArch then
              toolBasename
            else
              lib.getExe' toolDrv "${crossTargetPrefix}${toolBasename}";
        in
        {
          "ld" = absOrRelPath toolchain.buildPackages.binutils "ld";
          "as" = absOrRelPath toolchain.buildPackages.binutils "as";
          "cc" = absOrRelPath toolchain.stdenv.cc "cc";
        };
    in
    {
      x86_64 = genToolsFromToolchain x86_64PkgsCrossToolchain;
      aarch64 = genToolsFromToolchain aarch64PkgsCrossToolchain;
      riscv64 = genToolsFromToolchain riscv64PkgsCrossToolchain;
    };
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
  ];

  nativeBuildInputs = [
    harec
    makeWrapper
    qbe
    scdoc
  ];

  buildInputs = [
    binutils-unwrapped
    harec
    qbe
    tzdata
  ];

  makeFlags =
    [
      "HARECACHE=.harecache"
      "PREFIX=${builtins.placeholder "out"}"
      "ARCH=${arch}"
      "VERSION=${finalAttrs.version}-nixpkgs"
      "QBEFLAGS=-t${qbePlatform}"
      "CC=${stdenv.cc.targetPrefix}cc"
      "AS=${stdenv.cc.targetPrefix}as"
      "LD=${stdenv.cc.targetPrefix}ld"
      # Strip the variable of an empty $(SRCDIR)/hare/third-party, since nix does
      # not follow the FHS.
      "HAREPATH=$(SRCDIR)/hare/stdlib"
    ]
    ++ lib.optionals enableCrossCompilation [
      "RISCV64_AS=${embeddedOnBinaryTools.riscv64.as}"
      "RISCV64_CC=${embeddedOnBinaryTools.riscv64.cc}"
      "RISCV64_LD=${embeddedOnBinaryTools.riscv64.ld}"
      "AARCH64_AS=${embeddedOnBinaryTools.aarch64.as}"
      "AARCH64_CC=${embeddedOnBinaryTools.aarch64.cc}"
      "AARCH64_LD=${embeddedOnBinaryTools.aarch64.ld}"
      "x86_64_AS=${embeddedOnBinaryTools.x86_64.as}"
      "x86_64_CC=${embeddedOnBinaryTools.x86_64.cc}"
      "x86_64_LD=${embeddedOnBinaryTools.x86_64.ld}"
    ];

  enableParallelBuilding = true;

  # Append the distribution name to the version
  env.LOCALVER = "nixpkgs";

  strictDeps = true;

  doCheck = true;

  postConfigure = ''
    ln -s configs/${platform}.mk config.mk
  '';

  postFixup = ''
    wrapProgram $out/bin/hare \
      --prefix PATH : ${
        lib.makeBinPath [
          binutils-unwrapped
          harec
          qbe
        ]
      }
  '';

  setupHook = ./setup-hook.sh;

  passthru = {
    updateScript = gitUpdater { };
    tests = lib.optionalAttrs enableCrossCompilation {
      crossCompilation = callPackage ./cross-compilation-tests.nix { hare = finalAttrs.finalPackage; };
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
