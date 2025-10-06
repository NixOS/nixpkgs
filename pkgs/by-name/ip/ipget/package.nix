{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

buildGoModule rec {
  pname = "ipget";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipget";
    rev = "v${version}";
    hash = "sha256-7/wXrjnd7YD2qhVvP0yBMJDkDZjxJC1vZcQuqVd44rU=";
  };

  vendorHash = "sha256-b6Lulzi7zgO0VdWboxi5Vibx8cjuZ6r6O1PJvYubZu4=";

  postPatch = ''
    # main module (github.com/ipfs/ipget) does not contain package github.com/ipfs/ipget/sharness/dependencies
    rm -r sharness/dependencies/
  '';

  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) ipget;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Retrieve files over IPFS and save them locally";
    homepage = "https://ipfs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Luflosi ];
    mainProgram = "ipget";
  };
}
