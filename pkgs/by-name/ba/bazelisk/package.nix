{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "bazelisk";
  version = "1.27.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazelisk";
    rev = "v${version}";
    sha256 = "sha256-RPatTc97xYs5lhVCOjInNrNrL1UBsocdHn0C5yUHIxY=";
  };

  vendorHash = "sha256-gv5x0BbckeGkYa5rzCmyUkvmRsmI5YPy04HVN9Z1Rgc=";

  ldflags = [
    "-s"
    "-w"
    "-X main.BazeliskVersion=${version}"
  ];

  meta = {
    description = "User-friendly launcher for Bazel";
    mainProgram = "bazelisk";
    longDescription = ''
      BEWARE: This package does not work on NixOS.
    '';
    homepage = "https://github.com/bazelbuild/bazelisk";
    changelog = "https://github.com/bazelbuild/bazelisk/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ elasticdog ];
  };
}
