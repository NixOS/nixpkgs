{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "bazelisk";
  version = "1.22.1";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-C5kCCSvIcjZPRXS8ckoHusYCZ4IfsaHeyQC7jLdjZQY=";
  };

  vendorHash = "sha256-q8W+WSOxR/VC0uU8c2PVZwIer2CDUdDQ64AA2K6KghM=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.BazeliskVersion=${version}"
  ];

  meta = with lib; {
    description = "User-friendly launcher for Bazel";
    mainProgram = "bazelisk";
    longDescription = ''
      BEWARE: This package does not work on NixOS.
    '';
    homepage = "https://github.com/bazelbuild/bazelisk";
    changelog = "https://github.com/bazelbuild/bazelisk/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ elasticdog ];
  };
}
