{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gauge";
  version = "1.6.35";

  patches = [
    # adds a check which adds an error message when trying to
    # install plugins imperatively when using the wrapper
    ./nix-check.patch
  ];

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6WsyW4xlKCZO4xvvVr+O+WbmkQHp0RmXGD+HBcilMgo=";
  };

  vendorHash = "sha256-nQM3Ss4xQCkkOrJ1S2s0tdDr5O9SrmPnvT3Y4Ekz600=";

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
    ];
  };
})
