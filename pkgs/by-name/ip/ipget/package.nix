{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ipget";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipget";
    rev = "v${finalAttrs.version}";
    hash = "sha256-J3b3v8D/lmHOfqAKi4TvXlDd7CR2P8Nk2EEQEQg+j2E=";
  };

  vendorHash = "sha256-aQU9uX73xUeEf7QAt9Y+BQgjS4phP5+zTI54JH0kqRY=";

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
