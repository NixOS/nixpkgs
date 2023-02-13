import ./make-test-python.nix ({ pkgs, ... }: {
  name = "nixos-rebuild-specialisations";

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

      system.extraDependencies = with pkgs; [
        curl
        desktop-file-utils
        docbook5
        docbook_xsl_ns
        grub2
        kmod.dev
        libarchive
        libarchive.dev
        libxml2.bin
        libxslt.bin
        python3Minimal
        shared-mime-info
        stdenv
        sudo
        xorg.lndir
      ];

      virtualisation = {
        cores = 2;
        memorySize = 2048;
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

          boot.loader.grub = {
            enable = true;
            device = "/dev/vda";
            forceInstall = true;
          };

          documentation.enable = false;

          environment.systemPackages = [
            (pkgs.writeShellScriptBin "parent" "")
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
      machine.start()
      machine.succeed("udevadm settle")
      machine.wait_for_unit("multi-user.target")

      machine.succeed("nixos-generate-config")
      machine.copy_from_host(
          "${configFile}",
          "/etc/nixos/configuration.nix",
      )

      with subtest("Switch to the base system"):
          machine.succeed("nixos-rebuild switch")
          machine.succeed("parent")
          machine.fail("foo")
          machine.fail("bar")

      with subtest("Switch from base system into a specialization"):
          machine.succeed("nixos-rebuild switch --specialisation foo")
          machine.succeed("parent")
          machine.succeed("foo")
          machine.fail("bar")

      with subtest("Switch from specialization into another specialization"):
          machine.succeed("nixos-rebuild switch -c bar")
          machine.succeed("parent")
          machine.fail("foo")
          machine.succeed("bar")

      with subtest("Switch from specialization into the base system"):
          machine.succeed("nixos-rebuild switch")
          machine.succeed("parent")
          machine.fail("foo")
          machine.fail("bar")

      with subtest("Switch into specialization using `nixos-rebuild test`"):
          machine.succeed("nixos-rebuild test --specialisation foo")
          machine.succeed("parent")
          machine.succeed("foo")
          machine.fail("bar")

      with subtest("Make sure nonsense command combinations are forbidden"):
          machine.fail("nixos-rebuild boot --specialisation foo")
          machine.fail("nixos-rebuild boot -c foo")
    '';
})
