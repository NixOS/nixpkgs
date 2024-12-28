{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
let
  version = "0.5.0";
in
buildGoModule {
  pname = "lazyjournal";
  inherit version;

  src = fetchFromGitHub {
    owner = "Lifailon";
    repo = "lazyjournal";
    tag = version;
    hash = "sha256-fqlHeqK861QWpT1KhZrn2nZhXcnpAYe/THNOWyrFxcs=";
  };

  vendorHash = "sha256-jh99+zlhr4ogig4Z2FFO6SZ2qTBkOUuiXo5iNk0VTi0=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for journalctl, file system logs, as well as Docker and Podman containers";
    homepage = "https://github.com/Lifailon/lazyjournal";
    license = with lib.licenses; [ mit ];
    platforms = with lib.platforms; unix ++ windows;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "lazyjournal";
  };
}
