{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-tools";
  version = "2025.1";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = version;
    sha256 = "sha256-akNSaZBM1cUuQG4Zg3wQLUv5YI+phW0XnAHOOo1YF6g=";
  };

  vendorHash = "sha256-HssfBnSKdVZVgf4f0mwsGTwhiszBlE2HmDy7cvyvJ60=";

  excludedPackages = [ "website" ];

  doCheck = false;

  meta = with lib; {
    description = "Collection of tools and libraries for working with Go code, including linters and static analysis";
    homepage = "https://staticcheck.io";
    license = licenses.mit;
    maintainers = with maintainers; [
      rvolosatovs
      kalbasit
      smasher164
    ];
  };
}
