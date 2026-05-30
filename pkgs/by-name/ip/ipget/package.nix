{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ipget";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipget";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dG7nb9v+gKotRPVtO8tKqkOQ089zKBk39HxXkSXoW/U=";
  };

  vendorHash = "sha256-+BOo/xSdB0xR8Rtumh+sjEL025PVxmNTmSCR1HjfW3w=";

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
})
