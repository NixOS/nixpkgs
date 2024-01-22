{ lib, buildGoModule, fetchFromGitHub }:
let
  version = "0.0.38";
in
buildGoModule {

  pname = "mcap-cli";

  inherit version;

  src = fetchFromGitHub {
    repo = "mcap";
    owner = "foxglove";
    rev = "releases/mcap-cli/v${version}";
    hash = "sha256-mwKWf0kJ3uMx1cLUac+AqXgQ1Af3tLDOCTFKgq8FtHE=";
  };

  vendorHash = "sha256-Gl0zLBTWscKGtVOS6rPRL/r8KHYHpZwoUDbEyCL4Ijk=";

  modRoot = "go/cli/mcap";

  GOWORK="off";

  # copy the local versions of the workspace modules
  postConfigure = ''
    chmod -R u+w vendor
    rm -rf vendor/github.com/foxglove/mcap/go/{mcap,ros}
    cp -r ../../{mcap,ros} vendor/github.com/foxglove/mcap/go
  '';

  checkFlags = [
    # requires git-lfs and network
    # https://github.com/foxglove/mcap/issues/895
    "-skip=TestCat|TestInfo"
  ];

  meta = with lib; {
    description = "MCAP CLI tool to inspect and fix MCAP files";
    homepage = "https://github.com/foxglove/mcap";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ squalus therishidesai ];
  };

}
