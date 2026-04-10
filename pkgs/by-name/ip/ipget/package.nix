{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ipget";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipget";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mOZdoOl+eVMNOy5gfxeqmzOUAnc39WNJYr1l5IVId8U=";
  };

  vendorHash = "sha256-oB6XWs649Aj6MYIhWBWXNgJkycsx/kGw9iEVy3nG9iw=";

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
