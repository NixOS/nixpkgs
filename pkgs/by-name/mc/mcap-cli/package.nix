{ lib, buildGoModule, fetchFromGitHub, nix-update-script
}:
let
  version = "0.0.44";
in
buildGoModule {

  pname = "mcap-cli";

  inherit version;

  src = fetchFromGitHub {
    repo = "mcap";
    owner = "foxglove";
    rev = "releases/mcap-cli/v${version}";
    hash = "sha256-OAL2z28FhMXlyVzgmLCzHNCpCeK7hIkQB6jd7v3WHHA=";
  };

  vendorHash = "sha256-ofJYarmnOHONu2lZ76GvSua0ViP1gr6968xAuQ/VRNk=";

  modRoot = "go/cli/mcap";

  env.GOWORK="off";

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

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "MCAP CLI tool to inspect and fix MCAP files";
    homepage = "https://github.com/foxglove/mcap";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ squalus therishidesai ];
    mainProgram = "mcap";
  };

}
