{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
, nixosTests
}:
buildGoModule rec {
  pname = "dovecot_exporter";
  version = "0.1.3-unstable-2019-07-19";

  src = fetchFromGitHub {
    owner = "kumina";
    repo = "dovecot_exporter";
    rev = "7ef79118ba619ff078594837377189477a4d059f";
    hash = "sha256-qJbIBSfHYgFztuivuNjleDa+Bx0KC4OklCh3IvK2XFI=";
  };

  vendorHash = "sha256-+B8sROL1h6ElBfAUBT286yJF9m9zoRvMOrf0z2SVCj0=";

  patches = [
    # Migrate the project to Go modules
    # https://github.com/kumina/dovecot_exporter/pull/23
    (fetchpatch {
      url = "https://github.com/kumina/dovecot_exporter/commit/b5184dd99cf8c79facf20cea281828d302327665.patch";
      hash = "sha256-OcdI1fJ/wumDI/wk5PQVot9+Gw/PnsiwgJY7dcRyEsc=";
    })
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) dovecot; };

  meta = {
    inherit (src.meta) homepage;
    description = "Prometheus metrics exporter for Dovecot";
    mainProgram = "dovecot_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ willibutz globin ];
  };
}
