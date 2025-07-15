{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dblab";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "danvergara";
    repo = "dblab";
    rev = "v${version}";
    hash = "sha256-PFS/9/UdoClktsTnkcILUdjLC9yjvMf60Tgb70lQ5pE=";
  };

  vendorHash = "sha256-WxIlGdd3Si3Lyf9FZOCAepDlRo2F3EDRy00EawkZATY=";

  ldflags = [ "-s -w -X main.version=${version}" ];

  # some tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Database client every command line junkie deserves";
    homepage = "https://github.com/danvergara/dblab";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
