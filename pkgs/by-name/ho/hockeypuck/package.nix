{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "hockeypuck";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "hockeypuck";
    repo = "hockeypuck";
    rev = finalAttrs.version;
    sha256 = "sha256-m1PI6YRFf2ZKvtsGtmTcERiB/7aZdhAcQODREb2K7ro=";
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
  };
})
