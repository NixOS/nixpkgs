{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, gitUpdater
, cmake
, python3
, withDynarec ? stdenv.hostPlatform.isAarch64
, runCommand
, hello-x86_64
, box64
}:

# Currently only supported on ARM
assert withDynarec -> stdenv.hostPlatform.isAarch64;

stdenv.mkDerivation rec {
  pname = "box64";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ptitSeb";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eMp2eSWMRJQvLRQKUirBua6Kt7ZtyebfUnKIlibkNFU=";
  };

  patches = [
    # Fix mmx & cppThreads tests on x86_64
    # Remove when version > 0.2.0
    (fetchpatch {
      url = "https://github.com/ptitSeb/box64/commit/3819aecf078fcf47b2bc73713531361406a51895.patch";
      hash = "sha256-11hy5Ol5FSE/kNJmXAIwNLbapldhlZGKtOLIoL6pYrg=";
    })
  ];

  nativeBuildInputs = [
    cmake
    python3
  ];

  cmakeFlags = [
    "-DNOGIT=ON"
    "-DARM_DYNAREC=${if withDynarec then "ON" else "OFF"}"
    "-DRV64=${if stdenv.hostPlatform.isRiscV64 then "ON" else "OFF"}"
    "-DPPC64LE=${if stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isLittleEndian then "ON" else "OFF"}"
  ] ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    "-DLD80BITS=ON"
    "-DNOALIGN=ON"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 0755 box64 "$out/bin/box64"

    runHook postInstall
  '';

  doCheck = true;

  doInstallCheck = true;

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
      nativeBuildInputs = [ box64 hello-x86_64 ];
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
    platforms = [ "x86_64-linux" "aarch64-linux" "riscv64-linux" "powerpc64le-linux" ];
  };
}
