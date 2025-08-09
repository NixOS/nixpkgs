{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stu,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "stu";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "stu";
    rev = "v${version}";
    hash = "sha256-2vnyRTdRr6Y8YlwBSXqcOir5xdu5msPSU3EbsB0Ya34=";
  };

  cargoHash = "sha256-Us4rQYq+1Akq3i31sPBIC1Df0moicnHF0J5++M8tC2U=";

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
