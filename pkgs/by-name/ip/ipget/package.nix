{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ipget";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipget";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j8CRJTqZZtZMeGEq8l4YBBXAwhX+EfO2aFMXS8/6Ek4=";
  };

  vendorHash = "sha256-vOuQVISXOpRsZLuJ89Lk3wQHtnt0l5PhnLiDcjGKbhs=";

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
