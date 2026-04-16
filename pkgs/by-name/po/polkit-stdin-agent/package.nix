{
  lib,
  rustPlatform,
  fetchFromGitea,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "polkit-stdin-agent";
  version = "0.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "r-vdp";
    repo = "polkit-stdin-agent";
    tag = "v${version}";
    hash = "sha256-kgqlUgL73QGXsIV7jzTsSbSZMIuILOG4cbW+/9Uw1WU=";
  };

  cargoHash = "sha256-iDQ2fy1X8C52awcq/SKjIZu+g0GK90yy4fft1mRV9ms=";

  strictDeps = true;
  __structuredAttrs = true;

  passthru.tests = { inherit (nixosTests) nixos-rebuild-target-host; };

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
}
