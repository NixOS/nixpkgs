{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "bazelisk";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1/J/Y2NlIghxQS/5CnGX+2z+glOeOZVEgSE4KWft9Zw=";
  };

  vendorHash = "sha256-kXv7q32cFD9mwWsFaod7QPn3el72P4ugVc4DGwez8v0=";

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
