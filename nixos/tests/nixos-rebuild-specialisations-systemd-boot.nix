import ./make-test-python.nix ({ pkgs, ... }: {
  name = "nixos-rebuild-specialisations-systemd-boot";

  nodes = {
    machine = { lib, pkgs, ... }: {
      imports = [
        ../modules/profiles/installation-device.nix
        ../modules/profiles/base.nix
      ];

      nix.settings = {
        substituters = lib.mkForce [ ];
        hashed-mirrors = null;
        connect-timeout = 1;
      };

      system.includeBuildDependencies = true;

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      environment.systemPackages = [ pkgs.efibootmgr ];

      # TODO: Lower these values.
      virtualisation = {
        cores = 16;
        memorySize = 8192;
        useBootLoader = true;
        useEFIBoot = true;
      };
    };
  };

  testScript =
    let
      configFile = pkgs.writeText "configuration.nix" ''
        { lib, pkgs, ... }: {
          imports = [
            ./hardware-configuration.nix
            <nixpkgs/nixos/modules/testing/test-instrumentation.nix>
          ];

          documentation.enable = false;

          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;

          environment.systemPackages = with pkgs; [
            efibootmgr
            jq
            (writeShellScriptBin "parent" "")
          ];

          specialisation.foo = {
            inheritParentConfig = true;

            configuration = { ... }: {
              environment.systemPackages = [
                (pkgs.writeShellScriptBin "foo" "")
              ];
            };
          };

          specialisation.bar = {
            inheritParentConfig = true;

            configuration = { ... }: {
              environment.systemPackages = [
                (pkgs.writeShellScriptBin "bar" "")
              ];
            };
          };
        }
      '';

    in
    ''
      ## Arrange ##

      machine.start()
      machine.succeed("udevadm settle")
      machine.wait_for_unit("multi-user.target")

      machine.succeed("nixos-generate-config")
      machine.copy_from_host(
          "${configFile}",
          "/etc/nixos/configuration.nix",
      )

      ## Act ##

      machine.succeed("nixos-rebuild switch --specialisation foo")

      ## Assert ##

      # Assertion: foo specialisation was activated
      machine.succeed("parent")
      machine.succeed("foo")
      machine.fail("bar")

      # Assertion: foo specialisation is the default boot option
      expected_default_boot_path = "/boot/loader/entries/nixos-generation-2-specialisation-foo.conf";
      actual_default_boot_path = machine.succeed("bootctl list --json=short | jq --raw-output '.[] | select(.isDefault==true) | .path'").strip();
      assert actual_default_boot_path == expected_default_boot_path, f'Wrong default boot path.\nExpected: {expected_default_boot_path}\nGot:      {actual_default_boot_path}';
    '';
})
