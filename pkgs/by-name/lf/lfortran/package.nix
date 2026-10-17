{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  llvmPackages_19,
  pkg-config,
  re2c,
  bison,
  bash,
  zlib,
  zstd,
  pandoc,
  ninja,
  makeBinaryWrapper,
  runCommand,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lfortran";
  version = "0.66.0";

  src = fetchFromGitHub {
    owner = "lfortran";
    repo = "lfortran";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dEGAWlTGwYe9Tx7NkULpw0F3SsXYaMUMa99oAJxiZVk=";
  };

  strictDeps = true;

  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    re2c
    bison
    bash
    pandoc
    ninja
    makeBinaryWrapper
  ];

  nativeCheckInputs = [
    python3.pkgs.tomli
  ];

  buildInputs = [
    llvmPackages_19.llvm
    llvmPackages_19.libunwind
    zstd
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "LFORTRAN_BUILD_ALL" true)
    (lib.cmakeFeature "CMAKE_POLICY_DEFAULT_CMP0074" "NEW")
    (lib.cmakeBool "WITH_ZLIB" true)
    (lib.cmakeBool "USE_DYNAMIC_ZLIB" true)
    (lib.cmakeBool "WITH_ZSTD" true)
    (lib.cmakeBool "USE_DYNAMIC_ZSTD" true)
    (lib.cmakeBool "WITH_LLVM" true)
    (lib.cmakeBool "WITH_LSP" true)
    (lib.cmakeBool "WITH_STACKTRACE" false)
    (lib.cmakeBool "WITH_RUNTIME_STACKTRACE" true)
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "share/lfortran/lib")
  ];

  postPatch = ''
    patchShebangs build0.sh
    substituteInPlace build0.sh \
      --replace-fail "ci/version.sh" "echo ${finalAttrs.version} > version"
    echo "${finalAttrs.version}" > version
  '';

  preCheck = ''
    export LFORTRAN_LINKER=cc
  '';

  doCheck = true;

  postInstall = ''
    wrapProgram $out/bin/lfortran \
      --prefix PATH : ${lib.makeBinPath [ llvmPackages_19.clang ]}
  '';

  passthru = {
    updateScript = nix-update-script { };

    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };

      compile-and-run =
        runCommand "${finalAttrs.pname}-test-compile"
          {
            nativeBuildInputs = [ finalAttrs.finalPackage ];
          }
          ''
            cat << 'EOF' > hello.f90
            program hello
              print *, "Hello from LFortran!"
            end program hello
            EOF
            lfortran hello.f90 -o hello
            ./hello | grep -F "Hello from LFortran!"
            touch $out
          '';
    };
  };

  meta = {
    description = "Modern interactive LLVM-based Fortran compiler";
    homepage = "https://lfortran.org/";
    changelog = "https://github.com/lfortran/lfortran/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ taranarmo ];
    mainProgram = "lfortran";
    # https://github.com/lfortran/lfortran/issues/8643
    badPlatforms = [ "aarch64-linux" ];
    platforms = lib.platforms.unix;
  };
})
