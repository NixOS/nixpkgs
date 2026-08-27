{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "hockeypuck";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "hockeypuck";
    repo = "hockeypuck";
    rev = finalAttrs.version;
    sha256 = "sha256-EyXLOttABKMFKjXD/L1tXx7kvO2TEy2VZT8SIZJeLsI=";
  };

  modRoot = "src/hockeypuck/";
  vendorHash = null;
  doCheck = false; # Uses networking for tests

  passthru.tests = nixosTests.hockeypuck;

  meta = {
    description = "OpenPGP Key Server";
    homepage = "https://github.com/hockeypuck/hockeypuck";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
    teams = with lib.teams; [ ngi ];
  };
})
