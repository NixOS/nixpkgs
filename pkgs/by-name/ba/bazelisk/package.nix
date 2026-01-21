{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "bazelisk";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazelisk";
    rev = "v${version}";
    sha256 = "sha256-wpbJc4qF7UF8HG4tkk7jnsurO2snFIpcfKyRY1Ohby4=";
  };

  vendorHash = "sha256-PWqKq/2DFopeiecUL0iWnut8Kd/52U32sNSVGj3Ae5g=";

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
