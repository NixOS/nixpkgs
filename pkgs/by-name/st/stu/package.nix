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
  version = "0.4.2";
in
rustPlatform.buildRustPackage {
  pname = "stu";
  inherit version;

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "stu";
    rev = "v${version}";
    hash = "sha256-T5b3aCepUj8COrKReEaK4JeUbR7Sv7022xSCW8k8Iow=";
  };

  cargoHash = "sha256-DFG/9bnckqLezbitceLtM3CSnKAcQcZlv39VfbkyM/w=";

  buildInputs = lib.optionals stdenv.isDarwin [
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
