{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

buildGoModule {
  pname = "alertmanager-ntfy";
  version = "0-unstable-2025-06-27";

  src = fetchFromGitHub {
    owner = "alexbakker";
    repo = "alertmanager-ntfy";
    rev = "dc4ef93f7db7f046a775ef3e4a2a462b2afcec6c";
    hash = "sha256-J+T3Mt+40vhL3DVBKKH86l45AKSlkT7h+TrfhsWwMac=";
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
