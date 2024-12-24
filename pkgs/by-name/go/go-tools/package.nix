{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-tools";
  version = "2024.1.1";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = version;
    sha256 = "sha256-VD6WB0Rcwo41MqZUNVlLGl2yRGZKRGGLGBPvS+ISF4c=";
  };

  vendorHash = "sha256-OZ67BWsIUaU24BPQ1VjbGE4GkDZUKgbBG3ynUVXvyaU=";

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
