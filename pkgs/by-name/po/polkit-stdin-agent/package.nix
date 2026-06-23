{
  lib,
  rustPlatform,
  fetchFromGitea,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "polkit-stdin-agent";
  version = "0.3.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "r-vdp";
    repo = "polkit-stdin-agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nl/+IBbUEsxSKSWLXwUB3mV4iAG0z9mv+Bl6CSeFzR4=";
  };

  cargoHash = "sha256-Eb/7ejVmtG5FNSh66gZO3337KCPNi+xtYVC5qyFKJzg=";

  strictDeps = true;
  __structuredAttrs = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) nixos-rebuild-target-host; };
  };

  meta = {
    description = "Non-interactive polkit authentication agent that answers PAM prompts from a file descriptor";
    longDescription = ''
      Registers a per-process polkit authentication agent for a wrapped
      command and answers the PAM conversation from a file descriptor
      instead of /dev/tty, giving run0 / systemd-run the same
      "password on stdin" ergonomics as `sudo --stdin`.

      Used by `nixos-rebuild --elevate=run0 --ask-elevate-password` to
      authenticate on a target host over SSH without allocating a TTY.
    '';
    homepage = "https://codeberg.org/r-vdp/polkit-stdin-agent";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rvdp ];
    platforms = lib.platforms.linux;
    mainProgram = "polkit-stdin-agent";
  };
})
