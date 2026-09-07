{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "fastly-exporter";
  version = "10.3.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "fastly-exporter";
    rev = "v${version}";
    hash = "sha256-zxbbvdgEWbBWKjdWKzu0GTqwE3IOnBYK2WjkSJ8Rb9w=";
  };

  vendorHash = "sha256-TtR2jdccSjNyZ6y5STwJC/isI1Nqno7lUu5iNBr+KCg=";

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) fastly;
  };

  meta = {
    description = "Prometheus exporter for the Fastly Real-time Analytics API";
    homepage = "https://github.com/fastly/fastly-exporter";
    license = lib.licenses.asl20;
    mainProgram = "fastly-exporter";
  };
}
