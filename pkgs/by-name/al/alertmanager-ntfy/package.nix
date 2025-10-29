{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "alertmanager-ntfy";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "alexbakker";
    repo = "alertmanager-ntfy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aVK8HCRXRprNoBhILLN7F/Fb3RePPzBW4vBMnQr9zRU=";
  };

  vendorHash = "sha256-CpVGLM6ZtfYODhP6gzWGcnpEuDvKRiMWzoPNm2qtML4=";

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/alertmanager-ntfy --help > /dev/null

    runHook postInstallCheck
  '';

  passthru = {
    tests = { inherit (nixosTests.prometheus) alertmanager-ntfy; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Forwards Prometheus Alertmanager notifications to ntfy.sh";
    homepage = "https://github.com/alexbakker/alertmanager-ntfy";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "alertmanager-ntfy";
  };
})
