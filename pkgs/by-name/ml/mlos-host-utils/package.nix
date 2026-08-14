{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "mlos-host-utils";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "MopigamesYT";
    repo = "moonlight-os";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TZDaNAV+v7reKiBllkbESQ1/n1ItGKFDNGMUcuNcXcM=";
  };

  __structuredAttrs = true;

  # The agent is one directory of a repository that is otherwise an ISO
  # build, so the Go module is not at the root.
  modRoot = "host-utils";

  # Standard library only -- there is no go.sum and nothing to vendor.
  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "USB passthrough agent for the PC you stream from with Moonlight OS";
    longDescription = ''
      The host PC half of USB passthrough for Moonlight OS. Moonlight OS says
      which USB devices are plugged into the thin client; this agent attaches
      them to the machine the game is actually running on, over USB/IP.

      Note that `mlos-host-utils install` is meant for imperative distributions:
      it installs a usbip package with the system package manager and writes a
      unit into /etc/systemd/system, neither of which survives a rebuild. On
      NixOS, run the agent from a systemd service of your own, or use the
      services.mlos-host-utils module the upstream flake provides.
    '';
    homepage = "https://github.com/MopigamesYT/moonlight-os";
    changelog = "https://github.com/MopigamesYT/moonlight-os/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    mainProgram = "mlos-host-utils";
    maintainers = with lib.maintainers; [ mopigames ];
    platforms = lib.platforms.linux;
  };
})
