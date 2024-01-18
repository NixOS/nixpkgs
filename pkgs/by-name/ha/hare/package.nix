{ lib
, stdenv
, fetchFromSourcehut
, binutils-unwrapped
, harec
, makeWrapper
, qbe
, scdoc
, tzdata
, substituteAll
, callPackage
, enableCrossCompilation ? (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.is64bit)
, pkgsCross
, x86_64PkgsCrossToolchain ? pkgsCross.gnu64
, aarch64PkgsCrossToolchain ? pkgsCross.aarch64-multiplatform
, riscv64PkgsCrossToolchain ? pkgsCross.riscv64
}:

# There's no support for `aarch64-freebsd` or `riscv64-freebsd` on nix.
# See `lib.systems.doubles.aarch64` and `lib.systems.doubles.riscv64`.
assert let
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
  # We use harec's override of qbe until 1.2 is released, but the `qbe` argument
  # is kept to avoid breakage.
  qbe = harec.qbeUnstable;
  # https://harelang.org/platforms/
  arch = stdenv.hostPlatform.uname.processor;
  platform = lib.toLower stdenv.hostPlatform.uname.system;
  embeddedOnBinaryTools =
    let
      genToolsFromToolchain = toolchain:
        let
          crossTargetPrefix = toolchain.stdenv.cc.targetPrefix;
          toolchainArch = toolchain.stdenv.hostPlatform.uname.processor;
          absOrRelPath = toolDrv: toolBasename:
            if arch == toolchainArch then toolBasename
            else lib.getExe' toolDrv "${crossTargetPrefix}${toolBasename}";
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
  version = "unstable-2023-11-27";

  outputs = [ "out" "man" ];

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare";
    rev = "d94f355481a320fb2aec13ef62cb3bfe2416f5e4";
    hash = "sha256-Mpl3VO4xvLCKHeYr/FPuS6jl8CkyeqDz18mQ6Zv05oc=";
  };

  patches = [
    # Replace FHS paths with nix store
    (substituteAll {
      src = ./001-tzdata.patch;
      inherit tzdata;
    })
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

  makeFlags = [
    "HARECACHE=.harecache"
    "PREFIX=${builtins.placeholder "out"}"
    "PLATFORM=${platform}"
    "ARCH=${arch}"
    # Strip the variable of an empty $(SRCDIR)/hare/third-party, since nix does
    # not follow the FHS.
    "HAREPATH=$(SRCDIR)/hare/stdlib"
  ] ++ lib.optionals enableCrossCompilation [
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

  preConfigure = ''
    ln -s config.example.mk config.mk
  '';

  postFixup = ''
    wrapProgram $out/bin/hare \
      --prefix PATH : ${lib.makeBinPath [binutils-unwrapped harec qbe]}
  '';

  setupHook = ./setup-hook.sh;

  passthru = {
    tests = lib.optionalAttrs enableCrossCompilation {
      crossCompilation = callPackage ./cross-compilation-tests.nix {
        hare = finalAttrs.finalPackage;
      };
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
