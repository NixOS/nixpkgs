{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "prometheus-klipper-exporter";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "scross01";
    repo = "prometheus-klipper-exporter";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-TcGD7WjExo1/rgwVUSPmKFJEQZhttSgBIY3gKyfcwtQ=";
  };

  vendorHash = "sha256-VebaCzdPGl0hOHRXvwZb4aDzXlDZ57v/QVYzuagvvOM=";

  doCheck = true;

  passthru = {
    tests = {
      inherit (nixosTests.prometheus-exporters) process;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Prometheus Exporter for Klipper";
    homepage = "https://github.com/scross01/prometheus-klipper-exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wulfsta ];
    platforms = lib.platforms.linux;
  };
})
