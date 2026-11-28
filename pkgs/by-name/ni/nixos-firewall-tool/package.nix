{
  stdenvNoCC,
  lib,
  bash,
  installShellFiles,
  runCommand,
  buildPackages,
  nixosTests,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nixos-firewall-tool";
  version = lib.trivial.release;
  src = builtins.filterSource (name: _: !(lib.hasSuffix ".nix" name)) ./.;

  strictDeps = true;
  buildInputs = [ bash ];
  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    patchShebangs --host nixos-firewall-tool
  '';

  installPhase = ''
    installBin nixos-firewall-tool
    installManPage nixos-firewall-tool.1
    installShellCompletion nixos-firewall-tool.{bash,fish}
  '';

  passthru.tests = {
    shellcheck = runCommand "nixos-firewall-tool-shellcheck" { } ''
      ${lib.getExe buildPackages.shellcheck-minimal} ${finalAttrs.src}/nixos-firewall-tool
      touch $out
    '';
    inherit (nixosTests) firewall firewall-nftables;
  };

  meta = {
    description = "Tool to temporarily manipulate the NixOS firewall";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      clerie
      rvfg
      garyguo
    ];
    platforms = lib.platforms.linux;
    mainProgram = "nixos-firewall-tool";
  };
})
