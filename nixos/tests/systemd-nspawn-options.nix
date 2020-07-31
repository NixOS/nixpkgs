# Test for NixOS container options.
let nixos =
  import <nixpkgs/nixos/lib/eval-config.nix> {
    modules = [
      ({...}: {
        config = {
          boot.isContainer = true;
          networking.useDHCP = false;
        };
      })
    ];
  };
in

import ./make-test-python.nix ({ pkgs, ...} : {
  name = "systemd-nspawn-options";

  machine =
    { pkgs, ... }:
    {
      systemd.nspawn.test-container = {
        environment = {
          IN_CONTAINER = 1;
          PATH = "${pkgs.coreutils}/bin:${pkgs.utillinux}/bin:${pkgs.openresolv}/bin";
        };
        bind = {
          "/nix/var/nix/gcroots".source = "/nix/var/nix/gcroots/per-container/test-container";
          "/nix/var/nix/profiles".source = "/nix/var/nix/profiles/per-container/test-container";
        };
        bindReadOnly = {
          "/nix/store" = { source = "/nix/store"; mountOption = "norbind"; };
          "/nix/var/nix/daemon-socket".source = "/nix/var/nix/daemon-socket";
          "/nix/var/nix/db" = {};
        };
        temporaryFileSystem = [ "/tmp" { path = "/var/tmp"; mountOption = "mode=777"; } ];
        inaccessible = [ "/home" "/srv" ];
        # overlay = { "/usr" = [ "+/usr" "" ]; };
        # overlayReadOnly = { "/lib64" = [ "/lib" "/usr/lib64" ]; };
        virtualEthernetExtra = { "veth-container" = "veth-host"; };
        execConfig = {
          Boot = false;
          Parameters = "${nixos.config.system.build.toplevel}/init";
          NotifyReady = "yes";
          Hostname = "test-container";
          ResolvConf = "off";
          Timezone = "off";
          LinkJournal = "try-guest";
        };
        filesConfig = { ReadOnly = false; };
        networkConfig = { Private = true; };
      };
      systemd.disableUnprivilegedNspawn = false;
    };

  testScript =
    ''
      machine.wait_for_unit("default.target")
      machine.succeed("find /etc/systemd/nspawn -follow")
      conf = machine.succeed("cat /etc/systemd/nspawn/test-container.nspawn")

      # Checks types.int in environment
      assert 'Environment="IN_CONTAINER=1"' in conf

      # Checks practical instances of Bind and BindReadOnly
      assert (
          "Bind=/nix/var/nix/gcroots/per-container/test-container:/nix/var/nix/gcroots"
          in conf
      )
      assert (
          "Bind=/nix/var/nix/profiles/per-container/test-container:/nix/var/nix/profiles"
          in conf
      )
      assert "BindReadOnly=/nix/store:/nix/store:norbind" in conf
      assert "BindReadOnly=/nix/var/nix/daemon-socket:/nix/var/nix/daemon-socket" in conf
      assert "BindReadOnly=/nix/var/nix/db" in conf

      # Checks possible formats
      assert "TemporaryFileSystem=/tmp" in conf
      assert "TemporaryFileSystem=/var/tmp:mode=777" in conf
      assert "Inaccessible=/home" in conf
      assert "VirtualEthernetExtra=veth-host:veth-container" in conf
      # Fixme: overlayfs won't work on ZFS
      # assert "OverlayReadOnly=/lib:/usr/lib64:/lib64" in conf
      # assert "Overlay=+/usr::/usr" in conf

      # Checks filesConfig, networkConfig
      assert "ReadOnly=false" in conf
      assert "Private=true" in conf

      machine.succeed(
          "mkdir -p /var/lib/machines/test-container/{etc,home,srv,tmp,usr,lib} /nix/var/nix/{profiles,gcroots}/per-container/test-container",
          "chmod 0700 /var/lib/machines /nix/var/nix/{profiles,gcroots}/per-container",
          "touch /var/lib/machines/test-container/etc/os-release",
          "machinectl start test-container",
          "machinectl terminate test-container",
      )
    '';
})
