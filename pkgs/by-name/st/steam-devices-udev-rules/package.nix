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
<<<<<<< HEAD
  version = "1.0.0.61-unstable-2025-12-16";
=======
  version = "1.0.0.61-unstable-2025-10-18";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "steam-devices";
<<<<<<< HEAD
    rev = "daf01bc7e1e3d65987ab0f6e2c93707170a686b3";
    hash = "sha256-3eYZzn4b4RMCa6r1a1fFQohNNb4+5HfRtz8AaLDcoHs=";
=======
    rev = "4d7e6c1d8c54ec10fdb29daca679307ac5194825";
    hash = "sha256-KzDzZ03g1xil4G6yw67KGEHnWIWg6VZIkMy8n/kSgMs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Udev rules list for gaming devices";
    homepage = "https://github.com/ValveSoftware/steam-devices";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      azuwis
      yuannan
    ];
=======
  meta = with lib; {
    description = "Udev rules list for gaming devices";
    homepage = "https://github.com/ValveSoftware/steam-devices";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ azuwis ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
