{ lib, ... }:
{
  name = "nspawn-writable-store";

  meta.maintainers = with lib.maintainers; [ kiara ];

  containers = {
    writable = {
      virtualisation.writableStore = true;
    };

    readonly = {
      virtualisation.writableStore = false;
    };
  };

  testScript = ''
    build_derivation = """
      nix-build --option substitute false -E 'derivation {
        name = "t";
        builder = "/bin/sh";
        args = ["-c" "echo something > $out"];
        system = builtins.currentSystem;
        preferLocalBuild = true;
      }'
    """

    writable.start()
    readonly.start()

    with subtest("Nix store is writable"):
      writable.succeed(build_derivation)

    with subtest("Nix store is read only"):
      readonly.fail(build_derivation)
  '';
}
