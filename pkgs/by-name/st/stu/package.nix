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
  version = "0.5.0";
in
rustPlatform.buildRustPackage {
  pname = "stu";
  inherit version;

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "stu";
    rev = "v${version}";
    hash = "sha256-VETEcRuJk0cCWB5y8IRdycKcKb3uiAWOyjeZWCJykG4=";
  };

  cargoHash = "sha256-s2QvRberSz4egVO8A2h3cx8oUlZM1bV5qZ0U4EiuPRs=";

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
