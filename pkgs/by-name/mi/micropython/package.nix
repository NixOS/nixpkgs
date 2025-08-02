{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  python3,
  libffi,
  readline,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "micropython";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "micropython";
    repo = "micropython";
    rev = "v${version}";
    hash = "sha256-yH5omiYs07ZKECI+DAnpYq4T+r2O/RuGdtN+dhYxePc=";
    fetchSubmodules = true;

    # remove unused libraries from rp2 port's SDK. we leave this and the other
    # ports around for users who want to override makeFlags flags to build them.
    # https://github.com/micropython/micropython/blob/a61c446c0b34e82aeb54b9770250d267656f2b7f/ports/rp2/CMakeLists.txt#L17-L22
    #
    # shrinks uncompressed NAR by ~2.4G (though it is still large). there
    # doesn't seem to be a way to avoid fetching them in the first place.
    postFetch = ''
      rm -rf $out/lib/pico-sdk/lib/{tinyusb,lwip,btstack}
    '';
  };

  patches = [
    ./fix-cross-compilation.patch
    ./fix-mpy-cross-path.patch
  ];

  postPatch = ''
    # Fix cross-compilation by replacing uname and pkg-config
    substituteInPlace ports/unix/Makefile \
      --subst-var-by UNAME_S "${
        {
          "x86_64-linux" = "Linux";
          "i686-linux" = "Linux";
          "aarch64-linux" = "Linux";
          "armv7l-linux" = "Linux";
          "armv6l-linux" = "Linux";
          "riscv64-linux" = "Linux";
          "powerpc64le-linux" = "Linux";
          "x86_64-darwin" = "Darwin";
          "aarch64-darwin" = "Darwin";
        }.${stdenv.hostPlatform.system} or stdenv.hostPlatform.parsed.kernel.name
      }" \
      --subst-var-by PKG_CONFIG "${stdenv.cc.targetPrefix}pkg-config"
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    libffi
    readline
  ];

  makeFlags = [
    "-C"
    "ports/unix"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ] ++ lib.optionals (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux) [
    # Workaround for false positive gcc warning in mbedtls on aarch64
    "CFLAGS_EXTRA=-Wno-array-bounds"
  ]; # also builds mpy-cross

  # Set MPY_CROSS environment variable for cross-compilation
  preBuild = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    export MPY_CROSS="${lib.getExe' buildPackages.micropython "mpy-cross"}"
  '';

  enableParallelBuilding = true;

  doCheck = true;

  __darwinAllowLocalNetworking = true; # needed for select_poll_eintr test

  skippedTests =
    " -e select_poll_fd"
    + lib.optionalString (
      stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64
    ) " -e ffi_callback -e float_parse -e float_parse_doubleproc"
    + lib.optionalString (
      stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64
    ) " -e float_parse";

  checkPhase = ''
    runHook preCheck
    pushd tests
    ${python3.interpreter} ./run-tests.py ${skippedTests}
    popd
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 ports/unix/build-standard/micropython -t $out/bin
    install -Dm755 mpy-cross/build/mpy-cross -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Lean and efficient Python implementation for microcontrollers and constrained systems";
    homepage = "https://micropython.org";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [
      prusnak
      sgo
    ];
    mainProgram = "micropython";
  };
}
