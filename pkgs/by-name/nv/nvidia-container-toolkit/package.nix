{
  lib,
  glibc,
  fetchFromGitHub,
  buildGoModule,
  autoAddDriverRunpath,
}:

let
  # From https://github.com/NVIDIA/nvidia-container-toolkit/blob/03cbf9c6cd26c75afef8a2dd68e0306aace80401/Makefile#L54
  cliVersionPackage = "github.com/NVIDIA/nvidia-container-toolkit/internal/info";
in
buildGoModule (finalAttrs: {
  pname = "nvidia-container-toolkit";
  version = "1.20.1";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-container-toolkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DGu2T9RU4D9y7EfGe/7NxHUzV5b672ql1fdqXf185Dk=";
  };

  outputs = [
    "out"
    "tools"
  ];

  vendorHash = null;

  patches = [
    # This patch causes library lookups to first attempt loading via dlopen
    # before falling back to the regular symlink location and ldcache location.
    # Required on NixOS, where the driver libraries live outside the ldcache and
    # the FHS paths that the upstream locators search. Upstream tried to add an
    # equivalent locator but reverted it; tracked in
    # https://github.com/NVIDIA/nvidia-container-toolkit/issues/1677
    ./0001-Add-dlopen-discoverer.patch
  ];

  postPatch = ''
    substituteInPlace api/config/v1/config.go \
      --replace-fail '/usr/bin/nvidia-container-runtime-hook' "$tools/bin/nvidia-container-runtime-hook" \
      --replace-fail '/sbin/ldconfig' '${lib.getBin glibc}/sbin/ldconfig'

    substituteInPlace cmd/nvidia-cdi-hook/update-ldcache/update-ldcache.go \
      --replace-fail '/sbin/ldconfig' '${lib.getBin glibc}/sbin/ldconfig'
  '';

  subPackages = [
    "cmd/nvidia-cdi-hook"
    "cmd/nvidia-container-runtime"
    "cmd/nvidia-container-runtime.cdi"
    "cmd/nvidia-container-runtime-hook"
    "cmd/nvidia-container-runtime.legacy"
    "cmd/nvidia-ctk"
  ];

  # Based on upstream's Makefile:
  # https://github.com/NVIDIA/nvidia-container-toolkit/blob/03cbf9c6cd26c75afef8a2dd68e0306aace80401/Makefile#L64
  ldflags = [
    "-extldflags=-Wl,-z,lazy" # required with the incomplete NVML stub library.
    "-s" # "disable symbol table"
    "-X ${cliVersionPackage}.version=${finalAttrs.version}"
    "-X ${cliVersionPackage}.gitCommit=${finalAttrs.src.rev}"
  ];

  nativeBuildInputs = [
    autoAddDriverRunpath
  ];

  checkFlags =
    let
      skippedTests = [
        # Disable tests executing nvidia-container-runtime command.
        "TestGoodInput"
        "TestDuplicateHook"
      ];
    in
    [ "-skip=^(${lib.concatStringsSep "|" skippedTests})$" ];

  postInstall = ''
    mkdir -p $tools/bin
    mv $out/bin/{nvidia-cdi-hook,nvidia-container-runtime,nvidia-container-runtime.cdi,nvidia-container-runtime-hook,nvidia-container-runtime.legacy} $tools/bin
  '';

  meta = {
    homepage = "https://github.com/NVIDIA/nvidia-container-toolkit";
    description = "NVIDIA Container Toolkit";
    mainProgram = "nvidia-ctk";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      cpcloud
      christoph-heiss
      zeusec
    ];
  };
})
