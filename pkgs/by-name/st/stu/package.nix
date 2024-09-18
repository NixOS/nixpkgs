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
  version = "0.5.2";
in
rustPlatform.buildRustPackage {
  pname = "stu";
  inherit version;

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "stu";
    rev = "v${version}";
    hash = "sha256-R+ebDW6qkYK92seQHCWGKby544UrNGg+CfdK1NLIwas=";
  };

  cargoHash = "sha256-6uporgZTii97xLdEt7KXuSxoRMmFOGEGU3bPXP7Z14g=";

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
