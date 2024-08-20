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
  version = "0.5.1";
in
rustPlatform.buildRustPackage {
  pname = "stu";
  inherit version;

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "stu";
    rev = "v${version}";
    hash = "sha256-JLsUMZDXK89QmHLlGG9i5L+1e/redjk5ff6NiZdNsYo=";
  };

  cargoHash = "sha256-1sAK+F0Wghz2X78OzYJ3QN+5sdpNQw/pxHof0IoJPQo=";

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
