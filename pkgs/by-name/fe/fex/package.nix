{
  fetchFromGitHub,
  lib,
  llvmPackages,
  cmake,
  ninja,
  pkg-config,
  gitMinimal,
  qt5,
  python3,
}:

llvmPackages.stdenv.mkDerivation (finalAttrs: rec {
  pname = "fex";
  version = "2412";

  src = fetchFromGitHub {
    owner = "FEX-Emu";
    repo = "FEX";
    tag = "FEX-${version}";
    hash = "sha256-VwcfxdRMjE/yoe5q0p3j4FdEMOJdtq17moxiGWO+CN0=";
    fetchSubmodules = true;
  };

  patches = [
    # This is a workaround to get FEX working with NixOS's slightly weird binfmt
    # infrastructure.
    ./realpath.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    gitMinimal
    qt5.wrapQtAppsHook
    llvmPackages.bintools

    (python3.withPackages (
      pythonPackages: with pythonPackages; [
        setuptools
        libclang
      ]
    ))
  ];

  buildInputs = with qt5; [
    qtbase
    qtdeclarative
    qtquickcontrols
    qtquickcontrols2
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DUSE_LINKER=lld"
    "-DENABLE_LTO=True"
    "-DENABLE_ASSERTIONS=False"
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  strictDeps = true;
  doCheck = false; # broken on Apple silicon computers

  # Avoid wrapping anything other than FEXConfig, since the wrapped executables
  # don't seem to work when registered as binfmts.
  dontWrapQtApps = true;
  preFixup = ''
    wrapQtApp $out/bin/FEXConfig
  '';

  meta = {
    description = "Fast usermode x86 and x86-64 emulator for Arm64 Linux";
    homepage = "https://fex-emu.com/";
    platforms = [ "aarch64-linux" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ andre4ik3 ];
    mainProgram = "FEXBash";
  };
})
