{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tfupdate";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = "tfupdate";
    rev = "v${version}";
    sha256 = "sha256-WVYWoojNRAKmFt5kTaE86TNgodTld/vZ4O2LmLcU6sA=";
  };

  vendorHash = "sha256-BjusVkp7gN/w2uC1ZyUDaqvXvjEN6BVYNcwNZFOLjDc=";

  # Tests start http servers which need to bind to local addresses:
  # panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Update version constraints in your Terraform configurations";
    homepage = "https://github.com/minamijoyo/tfupdate";
    changelog = "https://github.com/minamijoyo/tfupdate/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Intuinewin qjoly ];
  };
}
