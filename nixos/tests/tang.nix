import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "tang";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ jfroche ];
    };

    nodes.server =
      {
        config,
        pkgs,
        modulesPath,
        ...
      }:
      {
        imports = [
          "${modulesPath}/../tests/common/auto-format-root-device.nix"
        ];
        virtualisation = {
          emptyDiskImages = [ 512 ];
          useBootLoader = true;
          useEFIBoot = true;
          # This requires to have access
          # to a host Nix store as
          # the new root device is /dev/vdb
          # an empty 512MiB drive, containing no Nix store.
          mountHostNixStore = true;
        };

        boot.loader.systemd-boot.enable = true;

        networking.interfaces.eth1.ipv4.addresses = [
          {
            address = "192.168.0.1";
            prefixLength = 24;
          }
        ];

        environment.systemPackages = with pkgs; [
          clevis
          tang
          cryptsetup
        ];
        services.tang = {
          enable = true;
          ipAddressAllow = [ "127.0.0.1/32" ];
        };
      };
    testScript = ''
      start_all()
      machine.wait_for_unit("sockets.target")

      with subtest("Check keys are generated"):
        machine.wait_until_succeeds("curl -v http://127.0.0.1:7654/adv")
        key = machine.wait_until_succeeds("tang-show-keys 7654")

      with subtest("Check systemd access list"):
        machine.succeed("ping -c 3 192.168.0.1")
        machine.fail("curl -v --connect-timeout 3 http://192.168.0.1:7654/adv")

      with subtest("Check basic encrypt and decrypt message"):
        machine.wait_until_succeeds(f"""echo 'Hello World' | clevis encrypt tang '{{ "url": "http://127.0.0.1:7654", "thp":"{key}"}}' > /tmp/encrypted""")
        decrypted = machine.wait_until_succeeds("clevis decrypt < /tmp/encrypted")
        assert decrypted.strip() == "Hello World"
        machine.wait_until_succeeds("tang-show-keys 7654")

      with subtest("Check encrypt and decrypt disk"):
        machine.succeed("cryptsetup luksFormat --force-password --batch-mode /dev/vdb <<<'password'")
        machine.succeed(f"""clevis luks bind -s1 -y -f -d /dev/vdb tang '{{ "url": "http://127.0.0.1:7654", "thp":"{key}" }}' <<< 'password' """)
        clevis_luks = machine.succeed("clevis luks list -d /dev/vdb")
        assert clevis_luks.strip() == """1: tang '{"url":"http://127.0.0.1:7654"}'"""
        machine.succeed("clevis luks unlock -d /dev/vdb")
        machine.succeed("find /dev/mapper -name 'luks*' -exec cryptsetup close {} +")
        machine.succeed("clevis luks unlock -d /dev/vdb")
        machine.succeed("find /dev/mapper -name 'luks*' -exec cryptsetup close {} +")
        # without tang available, unlock should fail
        machine.succeed("systemctl stop tangd.socket")
        machine.fail("clevis luks unlock -d /dev/vdb")
        machine.succeed("systemctl start tangd.socket")

      with subtest("Rotate server keys"):
        machine.succeed("${pkgs.tang}/libexec/tangd-rotate-keys -d /var/lib/tang")
        machine.succeed("clevis luks unlock -d /dev/vdb")
        machine.succeed("find /dev/mapper -name 'luks*' -exec cryptsetup close {} +")

      with subtest("Test systemd service security"):
          output = machine.succeed("systemd-analyze security tangd@.service")
          machine.log(output)
          assert output[-9:-1] == "SAFE :-}"
    '';
  }
)
