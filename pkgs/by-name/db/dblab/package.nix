{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dblab";
  version = "0.34.1";

  src = fetchFromGitHub {
    owner = "danvergara";
    repo = "dblab";
    rev = "v${version}";
    hash = "sha256-9gQjO9u/wONqmJjt5ejztWlFkqsJ8HUyPp3j5OyZEz4=";
  };

  vendorHash = "sha256-NhBT0dBS3jKgWHxCMVV6NUMcvqCbKS+tlm3y1YI/sAE=";

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
