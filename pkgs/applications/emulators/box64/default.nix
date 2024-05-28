{ lib
, stdenv
, fetchFromGitHub
, gitUpdater
, cmake
, python3
, withDynarec ? (stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isRiscV64)
, runCommand
, hello-x86_64
}:

# Currently only supported on ARM & RISC-V
assert withDynarec -> (stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isRiscV64);

stdenv.mkDerivation (finalAttrs: {
  pname = "box64";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "ptitSeb";
    repo = "box64";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P+m+JS3THh3LWMZYW6BQ7QyNWlBuL+hMcUtUbpMHzis=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  cmakeFlags = [
    "-DNOGIT=ON"

    # Arch mega-option
    "-DARM64=${lib.boolToString stdenv.hostPlatform.isAarch64}"
    "-DRV64=${lib.boolToString stdenv.hostPlatform.isRiscV64}"
    "-DPPC64LE=${lib.boolToString (stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isLittleEndian)}"
    "-DLARCH64=${lib.boolToString stdenv.hostPlatform.isLoongArch64}"
  ] ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    # x86_64 has no arch-specific mega-option, manually enable the options that apply to it
    "-DLD80BITS=ON"
    "-DNOALIGN=ON"
  ] ++ [
    # Arch dynarec
    "-DARM_DYNAREC=${lib.boolToString (withDynarec && stdenv.hostPlatform.isAarch64)}"
    "-DRV64_DYNAREC=${lib.boolToString (withDynarec && stdenv.hostPlatform.isRiscV64)}"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 0755 box64 "$out/bin/box64"

    runHook postInstall
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  installCheckPhase = ''
    runHook preInstallCheck

    echo Checking if it works
    $out/bin/box64 -v

    echo Checking if Dynarec option was respected
    $out/bin/box64 -v | grep ${lib.optionalString (!withDynarec) "-v"} Dynarec

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
    tests.hello = runCommand "box64-test-hello" {
      nativeBuildInputs = [ finalAttrs.finalPackage ];
    } ''
      # There is no actual "Hello, world!" with any of the logging enabled, and with all logging disabled it's hard to
      # tell what problems the emulator has run into.
      BOX64_NOBANNER=0 BOX64_LOG=1 box64 ${hello-x86_64}/bin/hello --version | tee $out
    '';
  };

  meta = with lib; {
    homepage = "https://box86.org/";
    description = "Lets you run x86_64 Linux programs on non-x86_64 Linux systems";
    license = licenses.mit;
    maintainers = with maintainers; [ gador OPNA2608 ];
    mainProgram = "box64";
    platforms = [ "x86_64-linux" "aarch64-linux" "riscv64-linux" "powerpc64le-linux" "loongarch64-linux" "mips64el-linux" ];
  };
})
