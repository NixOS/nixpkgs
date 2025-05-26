{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

buildGoModule {
  pname = "alertmanager-ntfy";
  version = "0-unstable-2025-05-04";

  src = fetchFromGitHub {
    owner = "alexbakker";
    repo = "alertmanager-ntfy";
    rev = "f05e3c029bab3bdfb9aefbddbfc6bd9c7d4aa80f";
    hash = "sha256-rKCJnffsBEXmTg2s0nqQf8BuHQnSgcwVBhC7gRzg4ew=";
  };

  vendorHash = "sha256-e1JAoDNm2+xB/bZcEGr5l4+va8GIg1R8pdj3d+/Y+UY=";

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/alertmanager-ntfy --help > /dev/null

    runHook postInstallCheck
  '';

  passthru = {
    tests = { inherit (nixosTests.prometheus) alertmanager-ntfy; };
    updateScript = nix-update-script { extraArgs = [ "--version=branch=master" ]; };
  };

  meta = {
    description = "Forwards Prometheus Alertmanager notifications to ntfy.sh";
    homepage = "https://github.com/alexbakker/alertmanager-ntfy";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "alertmanager-ntfy";
  };
}
