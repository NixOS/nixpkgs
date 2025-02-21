{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  darwin,
  stu,
  testers,
}:
let
  version = "0.6.3";
in
rustPlatform.buildRustPackage {
  pname = "stu";
  inherit version;

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "stu";
    rev = "v${version}";
    hash = "sha256-+hncQQSCYpVuRBQSHMNsfD89K+vL1LUJrCqrBIaRW1E=";
  };

  cargoHash = "sha256-tWgUVe8VLmEfroF4O3YfzU9yPerpKizuICWeSzsbV38=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.CoreGraphics
  ];

  passthru.tests.version = testers.testVersion { package = stu; };

  meta = {
    description = "Terminal file explorer for S3 buckets";
    changelog = "https://github.com/lusingander/stu/releases/tag/v${version}";
    homepage = "https://lusingander.github.io/stu/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.Nebucatnetzer ];
    mainProgram = "stu";
  };
}
