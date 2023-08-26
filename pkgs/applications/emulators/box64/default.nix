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
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "ptitSeb";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iCZv/WvqZkH6i23fSLA/p0nG5/CgzjyU5glVgje4c3w=";
  };

  patches = [
    # Fix crash due to regression in SDL1 AudioCallback signature in 0.2.4
    # Remove when version > 0.2.4
    (fetchpatch {
      name = "0001-box64-Fixed_signature_of_SDL1_AudioCallback.patch";
      url = "https://github.com/ptitSeb/box64/commit/5fabd602aea1937e3c5ce58843504c2492b8c0ec.patch";
      hash = "sha256-dBdKijTljCFtSJ2smHrbjH/ok0puGw4YEy/kluLl4AQ=";
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
