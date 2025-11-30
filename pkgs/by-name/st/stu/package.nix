{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stu,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "stu";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "stu";
    rev = "v${version}";
    hash = "sha256-zjfIBYFlEG6OQ+vWOJhVuek30uG1R28wJpUhRIMcYks=";
  };

  cargoHash = "sha256-CrliGsShW6wDkCpOVlK9m24BXr3lyxtU12GAdD/2dWE=";

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
