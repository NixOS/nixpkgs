{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bash,
  udevCheckHook,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "steam-devices-udev-rules";
  version = "1.0.0.61-unstable-2026-04-14";

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "steam-devices";
    rev = "7dde9ecb3c386363ecd9bd0a3b77e4756d200704";
    hash = "sha256-44ZO2etUxnldRCuNp6KpLArPrfAOuVPoXW1fl+KbHXA=";
  };

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/udev/rules.d/
    cp *.rules $out/lib/udev/rules.d/
    substituteInPlace $out/lib/udev/rules.d/*.rules --replace-warn "/bin/sh" "${bash}/bin/sh"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Udev rules list for gaming devices";
    homepage = "https://github.com/ValveSoftware/steam-devices";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      azuwis
      yuannan
    ];
  };
}
