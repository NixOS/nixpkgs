{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-tools";
  version = "2026.1";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = finalAttrs.version;
    sha256 = "sha256-cj/pHKwp7eGuOO1zhv5bFmuPHgsFytktLQmihhdYkfY=";
  };

  vendorHash = "sha256-Wu8+e0r0bkztLbxekbHktoKjg6c8q7ls5APSEdO8CKs=";

  excludedPackages = [ "website" ];

  meta = {
    description = "Collection of tools and libraries for working with Go code, including linters and static analysis";
    homepage = "https://staticcheck.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      rvolosatovs
      kalbasit
      smasher164
    ];
  };
})
