{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  callPackage,
}:

buildGoModule (finalAttrs: {
  pname = "hockeypuck";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "hockeypuck";
    repo = "hockeypuck";
    tag = finalAttrs.version;
    hash = "sha256-y1SoAgehsMdhb0dnLtTsZnzTbqE1L1v26Nzh0GLJyKI=";
  };

  modRoot = "src/hockeypuck/";
  vendorHash = null;
  doCheck = false; # Uses networking for tests

  passthru = {
    tests = nixosTests.hockeypuck;
    web = callPackage ./web.nix { };
  };

  meta = {
    changelog = "https://github.com/hockeypuck/hockeypuck/releases/tag/${finalAttrs.src.tag}";
    description = "OpenPGP Key Server";
    homepage = "https://github.com/hockeypuck/hockeypuck";
    license = lib.licenses.agpl3Plus;
    mainProgram = "hockeypuck";
    teams = with lib.teams; [ ngi ];
  };
})
