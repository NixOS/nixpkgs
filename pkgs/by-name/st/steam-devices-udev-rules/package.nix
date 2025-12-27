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
  version = "1.0.0.61-unstable-2025-12-16";

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "steam-devices";
    rev = "daf01bc7e1e3d65987ab0f6e2c93707170a686b3";
    hash = "sha256-3eYZzn4b4RMCa6r1a1fFQohNNb4+5HfRtz8AaLDcoHs=";
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
