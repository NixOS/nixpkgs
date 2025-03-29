{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stu,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "stu";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "stu";
    rev = "v${version}";
    hash = "sha256-gZaSSKlKTtOb/zxVwj0PFk1BqDDswyKv+fIHDn/4n3I=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hi3plLDMMft9jEo9whZrSBvZjLjezeWRmocQF0MlsfY=";

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
