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
  version = "1.0.0.61-unstable-2024-05-22";

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "steam-devices";
    rev = "e2971e45063f6b327ccedbf18e168bda6749155c";
    hash = "sha256-kBqWw3TlCSWS7gJXgza2ghemypQ0AEg7NhWqAFnal04=";
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

  meta = with lib; {
    description = "Udev rules list for gaming devices";
    homepage = "https://github.com/ValveSoftware/steam-devices";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ azuwis ];
  };
}
