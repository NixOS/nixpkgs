{ pkgs, ... }:

let
  inherit (pkgs) lib;
in

{
  name = "nix-required-mounts";
  meta.maintainers = with lib.maintainers; [ SomeoneSerge ];
  nodes.machine =
    { config, pkgs, ... }:
    {
      virtualisation.writableStore = true;
      system.extraDependencies = [ (pkgs.runCommand "deps" { } "mkdir $out").inputDerivation ];
      nix.nixPath = [ "nixpkgs=${../../..}" ];
      nix.settings.substituters = lib.mkForce [ ];
      nix.settings.system-features = [ "supported-feature" ];
      nix.settings.experimental-features = [ "nix-command" ];
      programs.nix-required-mounts.enable = true;
      programs.nix-required-mounts.allowedPatterns.supported-feature = {
        onFeatures = [ "supported-feature" ];
        paths = [
          "/supported-feature-files"
          {
            host = "/usr/lib/imaginary-fhs-drivers";
            guest = "/run/opengl-driver/lib";
          }
        ];
        unsafeFollowSymlinks = true;
      };
      users.users.person.isNormalUser = true;
      systemd.tmpfiles.rules = [
        "d /supported-feature-files 0755 person users -"
        "f /usr/lib/libcuda.so 0444 root root - fakeContent"
        "L /usr/lib/imaginary-fhs-drivers/libcuda.so 0444 root root - /usr/lib/libcuda.so"
      ];
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
    person_do("nix-build ${./test-structured-attrs.nix} --argstr feature supported-feature")
    person_do("nix-build ${./test-structured-attrs-empty.nix}")
  '';
}
