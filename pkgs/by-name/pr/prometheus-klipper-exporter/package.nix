{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "prometheus-klipper-exporter";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "scross01";
    repo = "prometheus-klipper-exporter";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-2BJkSKchUkLbUJke+4nB49MFp8OPPcytYAhtxCEdXO4=";
  };

  vendorHash = "sha256-8Y5o6Vh1Kn9CBG91qr1TQzyBHA0d31Femj9j1uW+4uk=";

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
