{ pkgs
, ...
}:

let
  inherit (pkgs) lib;
in

{
  name = "nix-required-mounts";
  meta.maintainers = with lib.maintainers; [ SomeoneSerge ];
  nodes.machine = { config, pkgs, ... }: {
    virtualisation.writableStore = true;
    system.extraDependencies = [ (pkgs.runCommand "deps" { } "mkdir $out").inputDerivation ];
    nix.nixPath = [ "nixpkgs=${../../..}" ];
    nix.settings.substituters = lib.mkForce [ ];
    nix.settings.system-features = [ "supported-feature" ]; nix.settings.experimental-features = [ "nix-command" ];
    programs.nix-required-mounts.enable = true;
    programs.nix-required-mounts.allowedPatterns.supported-feature = {
      onFeatures = [ "supported-feature" ];
      paths = [ "/supported-feature-files" ];
    };
    users.users.person.isNormalUser = true;
    virtualisation.fileSystems."/supported-feature-files".fsType = "tmpfs";
  };
  testScript = ''
    import shlex

    def person_do(cmd, succeed=True):
        cmd = shlex.quote(cmd)
        cmd = f"su person -l -c {cmd} &>/dev/console"

        if succeed:
            return machine.succeed(cmd)
        else:
            return machine.fail(cmd)

    start_all()

    person_do("nix-build ${./ensure-path-not-present.nix} --argstr feature supported-feature")
    person_do("nix-build ${./test-require-feature.nix} --argstr feature supported-feature")
    person_do("nix-build ${./test-require-feature.nix} --argstr feature unsupported-feature", succeed=False)
  '';
}
