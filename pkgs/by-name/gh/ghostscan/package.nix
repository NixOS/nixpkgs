{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  autoconf,
  automake,
  gettext,
  flex,
  bison,
  bpftools,
  vmlinux-to-elf,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghostscan";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "h2337";
    repo = "ghostscan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TQESv2qZL/ixcMC767n1VBMUpt6kG6F/SiFbPME8+S4=";
  };

  cargoHash = "sha256-rnge6Pftpw+C8w9jNVAAq0jY5MpQDxX8G8NV33hqIG0=";

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
    gettext
    flex
    bison
    bpftools
    vmlinux-to-elf
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unmask hidden rootkits, stealthy eBPF tricks and ghost processes";
    longDescription = ''
      ghostscan is the grab-it-run-it-read-it toolkit for responders
      who need a fast gut check on a Linux host.  Drop the binary on a
      box, run it once, and ghostscan walks the kernel, procfs, bpffs,
      systemd, cron, sockets, and more to surface the things an
      attacker would rather you never notice.
    '';
    homepage = "https://github.com/h2337/ghostscan";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "ghostscan";
  };
})
