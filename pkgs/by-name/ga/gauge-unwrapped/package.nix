{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gauge";
  version = "1.6.31";

  patches = [
    # adds a check which adds an error message when trying to
    # install plugins imperatively when using the wrapper
    ./nix-check.patch
  ];

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rvhWZgw0lq/YF8Js4UsIqiVOWe5/56bOaCq87+gdmPA=";
  };

  vendorHash = "sha256-FdTauyiGjmNRJNsVG4tS8PesC8J24NqQ4rmW3EgCoQk=";

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
