# This jobset defines the main NixOS channels (such as nixos-unstable
# and nixos-14.04). The channel is updated every time the ‘tested’ job
# succeeds, and all other jobs have finished (they may fail).

{ nixpkgs ? { outPath = (import ../lib).cleanSource ./..; revCount = 56789; shortRev = "gfedcba"; }
, stableBranch ? false
, supportedSystems ? [ "x86_64-linux" ]
, limitedSupportedSystems ? [ "i686-linux" "aarch64-linux" ]
}:

let

  nixpkgsSrc = nixpkgs; # urgh

  pkgs = import ./.. {};

  removeMaintainers = set: if builtins.isAttrs set
    then if (set.type or "") == "derivation"
      then set // { meta = builtins.removeAttrs (set.meta or {}) [ "maintainers" ]; }
      else pkgs.lib.mapAttrs (n: v: removeMaintainers v) set
    else set;

in rec {

  nixos = removeMaintainers (import ./release.nix {
    inherit stableBranch;
    supportedSystems = supportedSystems ++ limitedSupportedSystems;
    nixpkgs = nixpkgsSrc;
  });

  nixpkgs = builtins.removeAttrs (removeMaintainers (import ../pkgs/top-level/release.nix {
    inherit supportedSystems;
    nixpkgs = nixpkgsSrc;
  })) [ "unstable" ];

  tested =
    let
      onFullSupported = x: map (system: "${x}.${system}") supportedSystems;
      onAllSupported = x: map (system: "${x}.${system}") (supportedSystems ++ limitedSupportedSystems);
      onSystems = systems: x: map (system: "${x}.${system}")
        (pkgs.lib.intersectLists systems (supportedSystems ++ limitedSupportedSystems));
    in pkgs.releaseTools.aggregate {
      name = "nixos-${nixos.channel.version}";
      meta = {
        description = "Release-critical builds for the NixOS channel";
        maintainers = with pkgs.lib.maintainers; [ eelco ];
      };
      constituents = pkgs.lib.concatLists [
        [ "nixos.channel" ]
        (onFullSupported "nixos.dummy")
        (onAllSupported "nixos.iso_minimal")
        (onSystems ["x86_64-linux" "aarch64-linux"] "nixos.amazonImage")
        (onSystems ["x86_64-linux"] "nixos.iso_plasma5")
        (onSystems ["x86_64-linux"] "nixos.iso_gnome")
        (onFullSupported "nixos.manual")
        (onSystems ["x86_64-linux"] "nixos.ova")
        (onSystems ["aarch64-linux"] "nixos.sd_image")
        (onSystems ["x86_64-linux"] "nixos.tests.boot.biosCdrom")
        (onSystems ["x86_64-linux"] "nixos.tests.boot.biosUsb")
        (onFullSupported "nixos.tests.boot-stage1")
        (onSystems ["x86_64-linux"] "nixos.tests.boot.uefiCdrom")
        (onSystems ["x86_64-linux"] "nixos.tests.boot.uefiUsb")
        (onSystems ["x86_64-linux"] "nixos.tests.chromium")
        (onFullSupported "nixos.tests.containers-imperative")
        (onFullSupported "nixos.tests.containers-ip")
        (onSystems ["x86_64-linux"] "nixos.tests.docker")
        (onFullSupported "nixos.tests.ecryptfs")
        (onFullSupported "nixos.tests.env")
        (onFullSupported "nixos.tests.firefox-esr")
        (onFullSupported "nixos.tests.firefox")
        (onFullSupported "nixos.tests.firewall")
        (onFullSupported "nixos.tests.fontconfig-default-fonts")
        (onFullSupported "nixos.tests.gnome")
        (onFullSupported "nixos.tests.gnome-xorg")
        (onSystems ["x86_64-linux"] "nixos.tests.hibernate")
        (onFullSupported "nixos.tests.i3wm")
        (onSystems ["x86_64-linux"] "nixos.tests.installer.btrfsSimple")
        (onSystems ["x86_64-linux"] "nixos.tests.installer.btrfsSubvolDefault")
        (onSystems ["x86_64-linux"] "nixos.tests.installer.btrfsSubvols")
        (onSystems ["x86_64-linux"] "nixos.tests.installer.luksroot")
        (onSystems ["x86_64-linux"] "nixos.tests.installer.lvm")
        (onSystems ["x86_64-linux"] "nixos.tests.installer.separateBootFat")
        (onSystems ["x86_64-linux"] "nixos.tests.installer.separateBoot")
        (onSystems ["x86_64-linux"] "nixos.tests.installer.simpleLabels")
        (onSystems ["x86_64-linux"] "nixos.tests.installer.simpleProvided")
        (onSystems ["x86_64-linux"] "nixos.tests.installer.simpleUefiSystemdBoot")
        (onSystems ["x86_64-linux"] "nixos.tests.installer.simple")
        (onSystems ["x86_64-linux"] "nixos.tests.installer.swraid")
        (onFullSupported "nixos.tests.ipv6")
        (onFullSupported "nixos.tests.keymap.azerty")
        (onFullSupported "nixos.tests.keymap.colemak")
        (onFullSupported "nixos.tests.keymap.dvorak")
        (onFullSupported "nixos.tests.keymap.dvorak-programmer")
        (onFullSupported "nixos.tests.keymap.neo")
        (onFullSupported "nixos.tests.keymap.qwertz")
        (onFullSupported "nixos.tests.latestKernel.login")
        (onFullSupported "nixos.tests.lightdm")
        (onFullSupported "nixos.tests.login")
        (onFullSupported "nixos.tests.misc")
        (onFullSupported "nixos.tests.mutableUsers")
        (onFullSupported "nixos.tests.nat.firewall-conntrack")
        (onFullSupported "nixos.tests.nat.firewall")
        (onFullSupported "nixos.tests.nat.standalone")
        (onFullSupported "nixos.tests.networking.scripted.bond")
        (onFullSupported "nixos.tests.networking.scripted.bridge")
        (onFullSupported "nixos.tests.networking.scripted.dhcpOneIf")
        (onFullSupported "nixos.tests.networking.scripted.dhcpSimple")
        (onFullSupported "nixos.tests.networking.scripted.link")
        (onFullSupported "nixos.tests.networking.scripted.loopback")
        (onFullSupported "nixos.tests.networking.scripted.macvlan")
        (onFullSupported "nixos.tests.networking.scripted.privacy")
        (onFullSupported "nixos.tests.networking.scripted.routes")
        (onFullSupported "nixos.tests.networking.scripted.sit")
        (onFullSupported "nixos.tests.networking.scripted.static")
        (onFullSupported "nixos.tests.networking.scripted.virtual")
        (onFullSupported "nixos.tests.networking.scripted.vlan")
        (onFullSupported "nixos.tests.networking.networkd.bond")
        (onFullSupported "nixos.tests.networking.networkd.bridge")
        (onFullSupported "nixos.tests.networking.networkd.dhcpOneIf")
        (onFullSupported "nixos.tests.networking.networkd.dhcpSimple")
        (onFullSupported "nixos.tests.networking.networkd.link")
        (onFullSupported "nixos.tests.networking.networkd.loopback")
        # Fails nondeterministically (https://github.com/NixOS/nixpkgs/issues/96709)
        #(onFullSupported "nixos.tests.networking.networkd.macvlan")
        (onFullSupported "nixos.tests.networking.networkd.privacy")
        (onFullSupported "nixos.tests.networking.networkd.routes")
        (onFullSupported "nixos.tests.networking.networkd.sit")
        (onFullSupported "nixos.tests.networking.networkd.static")
        (onFullSupported "nixos.tests.networking.networkd.virtual")
        (onFullSupported "nixos.tests.networking.networkd.vlan")
        (onFullSupported "nixos.tests.systemd-networkd-ipv6-prefix-delegation")
        # fails with kernel >= 5.15 https://github.com/NixOS/nixpkgs/pull/152505#issuecomment-1005049314
        #(onFullSupported "nixos.tests.nfs3.simple")
        (onFullSupported "nixos.tests.nfs4.simple")
        (onSystems ["x86_64-linux"] "nixos.tests.oci-containers.podman")
        (onFullSupported "nixos.tests.openssh")
        (onFullSupported "nixos.tests.pantheon")
        (onFullSupported "nixos.tests.php.fpm")
        (onFullSupported "nixos.tests.php.httpd")
        (onFullSupported "nixos.tests.php.pcre")
        (onFullSupported "nixos.tests.plasma5")
        (onSystems ["x86_64-linux"] "nixos.tests.podman")
        (onFullSupported "nixos.tests.predictable-interface-names.predictableNetworkd")
        (onFullSupported "nixos.tests.predictable-interface-names.predictable")
        (onFullSupported "nixos.tests.predictable-interface-names.unpredictableNetworkd")
        (onFullSupported "nixos.tests.predictable-interface-names.unpredictable")
        (onFullSupported "nixos.tests.printing")
        (onFullSupported "nixos.tests.proxy")
        (onFullSupported "nixos.tests.sddm.default")
        (onFullSupported "nixos.tests.shadow")
        (onFullSupported "nixos.tests.simple")
        (onFullSupported "nixos.tests.sway")
        (onFullSupported "nixos.tests.switchTest")
        (onFullSupported "nixos.tests.udisks2")
        (onFullSupported "nixos.tests.xfce")
        (onSystems ["i686-linux"] "nixos.tests.zfs.installer")
        (onFullSupported "nixpkgs.emacs")
        (onFullSupported "nixpkgs.jdk")
        ["nixpkgs.tarball"]
      ];
    };
}
