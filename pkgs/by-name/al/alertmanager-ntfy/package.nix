{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

buildGoModule {
  pname = "alertmanager-ntfy";
  version = "0-unstable-2025-05-31";

  src = fetchFromGitHub {
    owner = "alexbakker";
    repo = "alertmanager-ntfy";
    rev = "76d5f772f70d6915c89da00414c20009b03cc361";
    hash = "sha256-newJ1fCMEE3gsZncWU899Q6cS6llPNwJlHT7HdLQZf8=";
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
