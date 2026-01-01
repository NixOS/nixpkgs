{
  stdenvNoCC,
  lib,
  bash,
  installShellFiles,
  buildPackages,
}:

stdenvNoCC.mkDerivation {
  name = "nixos-firewall-tool";

  src = builtins.filterSource (name: _: !(lib.hasSuffix ".nix" name)) ./.;

  strictDeps = true;
  buildInputs = [ bash ];
  nativeBuildInputs = [ installShellFiles ];
  nativeCheckInputs = [ buildPackages.shellcheck-minimal ];

  postPatch = ''
    patchShebangs --host nixos-firewall-tool
  '';

  installPhase = ''
    installBin nixos-firewall-tool
    installManPage nixos-firewall-tool.1
    installShellCompletion nixos-firewall-tool.{bash,fish}
  '';

  doCheck = buildPackages.shellcheck-minimal.compiler.bootstrapAvailable;
  checkPhase = ''
    shellcheck nixos-firewall-tool
  '';

<<<<<<< HEAD
  meta = {
    description = "Tool to temporarily manipulate the NixOS firewall";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Tool to temporarily manipulate the NixOS firewall";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      clerie
      rvfg
      garyguo
    ];
<<<<<<< HEAD
    platforms = lib.platforms.linux;
=======
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "nixos-firewall-tool";
  };
}
