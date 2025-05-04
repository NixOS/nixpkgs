{
  lib,
  stdenv,
  fetchFromGitHub,
  llvmPackages,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtbloader";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "TravMurav";
    repo = "dtbloader";
    tag = finalAttrs.version;
    hash = "sha256-qU7KB5oRd24rFN26kUhLYrG9VRakNuX8R0hWF0mVgvc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = with llvmPackages; [
    clang
    lld
    llvm
  ];

  # Disable hardening which adds incompatible flags like -fPIC
  hardeningDisable = [ "all" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/dtbloader/efi
    cp build-aarch64/dtbloader.efi $out/share/dtbloader/efi/

    mkdir -p $out/share/doc/dtbloader
    cp README.md $out/share/doc/dtbloader/

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "EFI driver that finds and installs DeviceTree into the UEFI configuration table";
    homepage = "https://github.com/TravMurav/dtbloader";
    changelog = "https://github.com/TravMurav/dtbloader/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    platforms = [
      # EFI file only works on aarch64 platforms
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ liberodark ];
  };
})
