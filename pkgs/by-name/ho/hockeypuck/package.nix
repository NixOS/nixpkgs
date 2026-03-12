{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "hockeypuck";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "hockeypuck";
    repo = "hockeypuck";
    rev = finalAttrs.version;
    sha256 = "0da3ffbqck0dr7d89gy2yillp7g9a4ziyjlvrm8vgkkg2fs8dlb1";
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
