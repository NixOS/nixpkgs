{
  buildPackages,
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  withDynarec ? stdenv.hostPlatform.isAarch32,
  runCommand,
  hello-x86_32,
}:

# Currently only supported on specific archs
assert withDynarec -> stdenv.hostPlatform.isAarch32;

stdenv.mkDerivation (finalAttrs: {
  pname = "box86";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "ptitSeb";
    repo = "box86";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ywsf+q7tWcAbrwbE/KvM6AJFNMJvqHKWD6tuANxrUt8=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  cmakeFlags =
    [
      (lib.cmakeBool "NOGIT" true)

      # Arch mega-option
      (lib.cmakeBool "POWERPCLE" (stdenv.hostPlatform.isPower && stdenv.hostPlatform.isLittleEndian))
    ]
    ++ lib.optionals stdenv.hostPlatform.isi686 [
      # x86 has no arch-specific mega-option, manually enable the options that apply to it
      (lib.cmakeBool "LD80BITS" true)
      (lib.cmakeBool "NOALIGN" true)
    ]
    ++ [
      # Arch dynarec
      (lib.cmakeBool "ARM_DYNAREC" (withDynarec && stdenv.hostPlatform.isAarch))
    ];

  installPhase = ''
    runHook preInstall

    install -Dm 0755 box86 "$out/bin/box86"

    runHook postInstall
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  installCheckPhase = ''
    runHook preInstallCheck

    echo Checking if it works
    $out/bin/box86 -v

    echo Checking if Dynarec option was respected
    $out/bin/box86 -v | grep ${lib.optionalString (!withDynarec) "-v"} Dynarec

    runHook postInstallCheck
  '';

  passthru = {
    # gitUpdater for local system, otherwise we're cross-compiling gitUpdater
    updateScript = buildPackages.gitUpdater { rev-prefix = "v"; };
    tests.hello =
      runCommand "box86-test-hello" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        # There is no actual "Hello, world!" with any of the logging enabled, and with all logging disabled it's hard to
        # tell what problems the emulator has run into.
        ''
          BOX86_NOBANNER=0 BOX86_LOG=1 box86 ${lib.getExe hello-x86_32} --version | tee $out
        '';
  };

  meta = {
    homepage = "https://box86.org/";
    description = "Lets you run x86 Linux programs on non-x86 Linux systems";
    changelog = "https://github.com/ptitSeb/box86/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gador
      OPNA2608
    ];
    mainProgram = "box86";
    platforms = [
      "i686-linux"
      "armv7l-linux"
      "powerpcle-linux"
      "loongarch64-linux"
      "mipsel-linux"
    ];
  };
})
