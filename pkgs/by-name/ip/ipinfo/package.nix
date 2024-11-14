{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ipinfo";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "cli";
    rev = "refs/tags/${pname}-${version}";
    hash = "sha256-sdQdCP2NotrdeqYrSd9c6sExFeuX54I4fxJfEyULPuk=";
  };

  vendorHash = null;

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Command Line Interface for the IPinfo API";
    homepage = "https://github.com/ipinfo/cli";
    changelog = "https://github.com/ipinfo/cli/releases/tag/ipinfo-${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
