{
  lib,
  stdenv,
  fetchFromSourcehut,
  harec,
  scdoc,
  tzdata,
  mailcap,
  replaceVars,
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
  lib.assertMsg (enableCrossCompilation -> isLinux && is64bit) ''
    The cross-compilation toolchains may only be enabled on the following platforms:
    ${concatStringsSep "\n" workingPlatforms}
  '';

let
  inherit (harec) qbe;
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
  version = "0.24.2";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare";
    rev = finalAttrs.version;
    hash = "sha256-61lckI0F+Ez5LR/8g6ftS0W7Q/+EU/1flTDFleBg6pc=";
  };

  patches = [
    # Replace FHS paths with nix store
    (replaceVars ./001-tzdata.patch {
      inherit tzdata;
    })
    # Don't build haredoc since it uses the build `hare` bin, which breaks
    # cross-compilation.
    ./002-dont-build-haredoc.patch
    # Hardcode harec and qbe.
    (replaceVars ./003-hardcode-qbe-and-harec.patch {
      harec_bin = lib.getExe harec;
      qbe_bin = lib.getExe qbe;
    })
    # Use mailcap `/etc/mime.types` for Hare's mime module
    (replaceVars ./004-use-mailcap-for-mimetypes.patch {
      inherit mailcap;
    })
  ];

  nativeBuildInputs = [
    harec
    qbe
    scdoc
  ];

  buildInputs = [
    harec
    qbe
  ];

  makeFlags = [
    "HARECACHE=.harecache"
    "PREFIX=${placeholder "out"}"
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
  ]
  ++ lib.optionals enableCrossCompilation crossCompMakeFlags;

  enableParallelBuilding = true;

  # Append the distribution name to the version
  env.LOCALVER = "nixpkgs";

  strictDeps = true;

  doCheck = true;

  postConfigure = ''
    ln -s configs/${platform}.mk config.mk
  '';

  passthru = {
    tests =
      lib.optionalAttrs enableCrossCompilation {
        crossCompilation = callPackage ./cross-compilation-tests.nix { hare = finalAttrs.finalPackage; };
      }
      // lib.optionalAttrs (stdenv.buildPlatform.canExecute stdenv.hostPlatform) {
        mimeModule = callPackage ./mime-module-test.nix { hare = finalAttrs.finalPackage; };
      }
      //
        lib.optionalAttrs (enableCrossCompilation && stdenv.buildPlatform.canExecute stdenv.hostPlatform)
          {
            crossCompilation = callPackage ./cross-compilation-tests.nix { hare = finalAttrs.finalPackage; };
          };
    # To be propagated by `hareHook`.
    inherit harec qbe;
  };

  meta = {
    homepage = "https://harelang.org/";
    description = "Systems programming language designed to be simple, stable, and robust";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "hare";
    inherit (harec.meta) platforms badPlatforms;
  };
})
