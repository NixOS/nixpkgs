{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "domain-exporter";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "domain_exporter";
    rev = "v${version}";
    hash = "sha256-LZsw3k/4h6nOVoaGiOASWrvIQf4wI6nSNuAjXsWcnd8=";
  };

  vendorHash = "sha256-gBcog+hw8yKYEBH6iokO7vnfDZn7zS0N/MWOGomxJGw=";

  doCheck = false; # needs internet connection

  passthru.tests = { inherit (nixosTests.prometheus-exporters) domain; };

  meta = {
    homepage = "https://github.com/caarlos0/domain_exporter";
    description = "Exports the expiration time of your domains as prometheus metrics";
    mainProgram = "domain_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mmilata
      peterhoeg
      caarlos0
    ];
  };
}
