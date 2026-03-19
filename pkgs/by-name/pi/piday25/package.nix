{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "piday25";
  version = "0-unstable-2026-03-18";

  src = fetchFromGitHub {
    owner = "elkasztano";
    repo = "piday25";
    rev = "3fdeb37e33572c0924fc8f23a62824df8f6a9496";
    hash = "sha256-iNc6NUEekk793j3Ob02H9NB4SH1anYsWzixr8OiglOE=";
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
