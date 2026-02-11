{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-tools";
  version = "2025.1.1";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = finalAttrs.version;
    sha256 = "sha256-ekSOXaVSFdzM76tcj1hbtzhYw4fnFX3VkTnsGtJanXg=";
  };

  vendorHash = "sha256-HssfBnSKdVZVgf4f0mwsGTwhiszBlE2HmDy7cvyvJ60=";

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
