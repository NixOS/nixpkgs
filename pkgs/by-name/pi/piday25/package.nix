{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "piday25";
  version = "0-unstable-2026-03-19";

  src = fetchFromGitHub {
    owner = "elkasztano";
    repo = "piday25";
    rev = "c5220bba1b22468d4ce3b93343132731c4138115";
    hash = "sha256-vmk2A3IW9lwRBg4xXTlNgF7b8S/+AciJY+FUhwdzgQ0=";
  };

  cargoHash = "sha256-3uztB5/VevFyEz3S+VlAUPgDrNDJcwaTnHuXXYAX+MY=";

  # upstream does not have any tests
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/piday25 > result
    diff -U3 --color=auto <(head -c12 result) <(echo -n 3.1415926535)

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

  meta = {
    description = "Multithreaded implementation of the Chudnovsky algorithm to calculate Pi";
    homepage = "https://github.com/elkasztano/piday25";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "piday25";
  };
}
