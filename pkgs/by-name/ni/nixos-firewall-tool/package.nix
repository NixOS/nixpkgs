{
  stdenvNoCC,
  lib,
  bash,
  installShellFiles,
  shellcheck-minimal,
}:

stdenvNoCC.mkDerivation {
  name = "nixos-firewall-tool";

  src = builtins.filterSource (name: _: !(lib.hasSuffix ".nix" name)) ./.;

  strictDeps = true;
  buildInputs = [ bash ];
  nativeBuildInputs = [ installShellFiles ];
  nativeCheckInputs = [ shellcheck-minimal ];

  postPatch = ''
    patchShebangs --host nixos-firewall-tool
  '';

  installPhase = ''
    installBin nixos-firewall-tool
    installManPage nixos-firewall-tool.1
    installShellCompletion nixos-firewall-tool.{bash,fish}
  '';

  # Skip shellcheck if GHC is not available, see writeShellApplication.
  doCheck =
    lib.meta.availableOn stdenvNoCC.buildPlatform shellcheck-minimal.compiler
    && (builtins.tryEval shellcheck-minimal.compiler.outPath).success;
  checkPhase = ''
    shellcheck nixos-firewall-tool
  '';

  meta = with lib; {
    description = "A tool to temporarily manipulate the NixOS firewall";
    license = licenses.mit;
    maintainers = with maintainers; [
      clerie
      rvfg
      garyguo
    ];
    platforms = platforms.linux;
    mainProgram = "nixos-firewall-tool";
  };
}
