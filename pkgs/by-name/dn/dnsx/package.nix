{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dnsx";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "dnsx";
    rev = "refs/tags/v${version}";
    hash = "sha256-scp0CDIO8F2TqpSCgXXfb8I83stvO/GZqSA5/BkN8pE=";
  };

  vendorHash = "sha256-WbFkBTPy4N+mAVSkq1q9XcNs1jk6YuBcYxiEmQV/TsM=";

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Fast and multi-purpose DNS toolkit";
    longDescription = ''
      dnsx is a fast and multi-purpose DNS toolkit allow to run multiple
      probers using retryabledns library, that allows you to perform
      multiple DNS queries of your choice with a list of user supplied
      resolvers.
    '';
    homepage = "https://github.com/projectdiscovery/dnsx";
    changelog = "https://github.com/projectdiscovery/dnsx/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
