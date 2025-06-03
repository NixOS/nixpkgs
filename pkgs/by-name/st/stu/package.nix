{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stu,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "stu";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "stu";
    rev = "v${version}";
    hash = "sha256-taxXk6GJ7ulPVPL4nUZwY+ln7Te54kM2xcLsRd7kpK0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qc2FvlMjPp0X6EQyxNwJdpB8D1i+QzxFv9qYf/F+gXg=";

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
