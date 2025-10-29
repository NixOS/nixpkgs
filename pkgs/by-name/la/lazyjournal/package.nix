{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
let
  version = "0.8.1";
in
buildGoModule {
  pname = "lazyjournal";
  inherit version;

  src = fetchFromGitHub {
    owner = "Lifailon";
    repo = "lazyjournal";
    tag = version;
    hash = "sha256-QHVwEesJZiySwEPeDZaU56uY+PJEJXCybvAezhwa59g=";
  };

  vendorHash = "sha256-Wl8DmEBt1YtTk9QEvWybSWRQm0Lnfd5q3C/wg+gP33g=";

  ldflags = [
    "-s"
    "-w"
  ];

  # All checks expect a FHS environment with e.g. log files present,
  # which is evidently not possible in a build environment
  doCheck = false;

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
