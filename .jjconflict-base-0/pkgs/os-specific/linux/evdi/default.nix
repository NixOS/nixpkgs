{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  libdrm,
  python3,
}:

let
  python3WithLibs = python3.withPackages (
    ps: with ps; [
      pybind11
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "evdi";
  version = "1.14.7";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = "evdi";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-z3GawjaokbmmUC1LihwGSnF3tUp9n/FO+kDiWvBq+mY=";
  };

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error"
    "-Wno-error=discarded-qualifiers" # for Linux 4.19 compatibility
    "-Wno-error=sign-compare"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildInputs = [
    kernel
    libdrm
    python3WithLibs
  ];

  makeFlags = kernel.makeFlags ++ [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  hardeningDisable = [
    "format"
    "pic"
    "fortify"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 module/evdi.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/evdi/evdi.ko
    install -Dm755 library/libevdi.so $out/lib/libevdi.so
    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = {
    broken = kernel.kernelOlder "4.19" || kernel.kernelAtLeast "6.12";
    changelog = "https://github.com/DisplayLink/evdi/releases/tag/v${finalAttrs.version}";
    description = "Extensible Virtual Display Interface";
    homepage = "https://www.displaylink.com/";
    license = with lib.licenses; [
      lgpl21Only
      gpl2Only
    ];
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.linux;
  };
})
