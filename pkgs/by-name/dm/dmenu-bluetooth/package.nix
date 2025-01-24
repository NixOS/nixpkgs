{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bluez,
  dmenu,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dmenu-bluetooth";
  version = "unstable-2023-07-16";

  src = fetchFromGitHub {
    owner = "Layerex";
    repo = "dmenu-bluetooth";
    rev = "96e2e3e1dd7ea2d2ab0c20bf21746aba8d70cc46";
    hash = "sha256-0G2PXWq9/JsLHnbOIJWSWWqfnBgOxaA8N2VyCbTUGmI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -D --target-directory=$out/bin/ ./dmenu-bluetooth

    wrapProgram $out/bin/dmenu-bluetooth \
      --prefix PATH ":" ${
        lib.makeBinPath [
          dmenu
          bluez
        ]
      }

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Script that generates a dmenu menu that uses bluetoothctl to connect to bluetooth devices and display status info";
    mainProgram = "dmenu-bluetooth";
    homepage = "https://github.com/Layerex/dmenu-bluetooth";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ludovicopiero ];
    platforms = lib.platforms.linux;
  };
})
