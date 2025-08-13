{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "piday25";
  version = "0-unstable-2025-03-13";

  src = fetchFromGitHub {
    owner = "elkasztano";
    repo = "piday25";
    rev = "68b417a3016c58a2948cb3b39c9bde985d82bdb8";
    hash = "sha256-58ZBRmB990Tp+/nkuRZA+8cjCRFUBzdzu93Sk5uvKOE=";
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
