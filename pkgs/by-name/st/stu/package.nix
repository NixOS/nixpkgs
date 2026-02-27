{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stu,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stu";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "stu";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DLZQq/pLvRQizjTWbGHqDkOW1iKDICun54Ku1i+kOB0=";
  };

  cargoHash = "sha256-nbHSrILQT4541cPGUpqKmTLKnXnXYCAHBjkC4vIbT9g=";

  passthru.tests.version = testers.testVersion { package = stu; };

  meta = {
    description = "Terminal file explorer for S3 buckets";
    changelog = "https://github.com/lusingander/stu/releases/tag/v${finalAttrs.version}";
    homepage = "https://lusingander.github.io/stu/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.Nebucatnetzer ];
    mainProgram = "stu";
  };
})
