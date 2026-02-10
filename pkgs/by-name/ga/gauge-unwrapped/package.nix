{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gauge";
  version = "1.6.22";

  patches = [
    # adds a check which adds an error message when trying to
    # install plugins imperatively when using the wrapper
    ./nix-check.patch
  ];

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6RJj+sDffqzdMlMkE/rJ7AEKYcxDQBR86fjlaNDb6M0=";
  };

  vendorHash = "sha256-nxd+3hKHLUiHpSGTJpD5QRFJ4e0Boq5MTijmND56Uug=";

  excludedPackages = [
    "build"
    "man"
  ];

  meta = {
    description = "Light weight cross-platform test automation";
    mainProgram = "gauge";
    homepage = "https://gauge.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      vdemeester
      marie
    ];
  };
})
