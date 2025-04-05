{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stu,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "stu";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "stu";
    rev = "v${version}";
    hash = "sha256-ks9QN9hVejgmQKJ5tZJx67IqgC37QKH3MEBwLYr/TZI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-HqfZ6g+TXt6MrBV40mLnuwp96r0YPLyFYs7GR4kpNbQ=";

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
