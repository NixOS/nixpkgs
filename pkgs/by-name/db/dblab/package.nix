{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dblab";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "danvergara";
    repo = "dblab";
    rev = "v${version}";
    hash = "sha256-Hcwuh+NGHp1nb6dS1CDC+M7onlNpJbkb6UAiC4j3ZiU=";
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
