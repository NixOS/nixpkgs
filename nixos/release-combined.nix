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

  allSupportedNixpkgs = builtins.removeAttrs (removeMaintainers (import ../pkgs/top-level/release.nix {
    supportedSystems = supportedSystems ++ limitedSupportedSystems;
    nixpkgs = nixpkgsSrc;
  })) [ "unstable" ];

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

  tested = pkgs.releaseTools.aggregate {
    name = "nixos-${nixos.channel.version}";
    meta = {
      description = "Release-critical builds for the NixOS channel";
      maintainers = with pkgs.lib.maintainers; [ eelco fpletz ];
    };
    constituents = [
      "nixos.channel"
      "nixos.dummy.x86_64-linux"
      "nixos.iso_minimal.aarch64-linux"
      "nixos.iso_minimal.i686-linux"
      "nixos.iso_minimal.x86_64-linux"
      "nixos.iso_plasma5.x86_64-linux"
      "nixos.manual.x86_64-linux"
      "nixos.ova.x86_64-linux"
      "nixos.sd_image.aarch64-linux"
      "nixos.tests.boot.biosCdrom.x86_64-linux"
      "nixos.tests.boot.biosUsb.x86_64-linux"
      "nixos.tests.boot-stage1.x86_64-linux"
      "nixos.tests.boot.uefiCdrom.x86_64-linux"
      "nixos.tests.boot.uefiUsb.x86_64-linux"
      "nixos.tests.chromium.x86_64-linux"
      "nixos.tests.containers-imperative.x86_64-linux"
      "nixos.tests.containers-ip.x86_64-linux"
      "nixos.tests.docker.x86_64-linux"
      "nixos.tests.ecryptfs.x86_64-linux"
      "nixos.tests.env.x86_64-linux"
      "nixos.tests.firefox-esr.x86_64-linux"
      "nixos.tests.firefox.x86_64-linux"
      "nixos.tests.firewall.x86_64-linux"
      "nixos.tests.fontconfig-default-fonts.x86_64-linux"
      "nixos.tests.gnome3.x86_64-linux"
      "nixos.tests.gnome3-xorg.x86_64-linux"
      "nixos.tests.hibernate.x86_64-linux"
      "nixos.tests.i3wm.x86_64-linux"
      "nixos.tests.installer.btrfsSimple.x86_64-linux"
      "nixos.tests.installer.btrfsSubvolDefault.x86_64-linux"
      "nixos.tests.installer.btrfsSubvols.x86_64-linux"
      "nixos.tests.installer.luksroot.x86_64-linux"
      "nixos.tests.installer.lvm.x86_64-linux"
      "nixos.tests.installer.separateBootFat.x86_64-linux"
      "nixos.tests.installer.separateBoot.x86_64-linux"
      "nixos.tests.installer.simpleLabels.x86_64-linux"
      "nixos.tests.installer.simpleProvided.x86_64-linux"
      "nixos.tests.installer.simpleUefiSystemdBoot.x86_64-linux"
      "nixos.tests.installer.simple.x86_64-linux"
      "nixos.tests.installer.swraid.x86_64-linux"
      "nixos.tests.ipv6.x86_64-linux"
      "nixos.tests.keymap.azerty.x86_64-linux"
      "nixos.tests.keymap.colemak.x86_64-linux"
      "nixos.tests.keymap.dvorak.x86_64-linux"
      "nixos.tests.keymap.dvp.x86_64-linux"
      "nixos.tests.keymap.neo.x86_64-linux"
      "nixos.tests.keymap.qwertz.x86_64-linux"
      "nixos.tests.lightdm.x86_64-linux"
      "nixos.tests.login.x86_64-linux"
      "nixos.tests.misc.x86_64-linux"
      "nixos.tests.mutableUsers.x86_64-linux"
      "nixos.tests.nat.firewall-conntrack.x86_64-linux"
      "nixos.tests.nat.firewall.x86_64-linux"
      "nixos.tests.nat.standalone.x86_64-linux"
      "nixos.tests.networking.scripted.bond.x86_64-linux"
      "nixos.tests.networking.scripted.bridge.x86_64-linux"
      "nixos.tests.networking.scripted.dhcpOneIf.x86_64-linux"
      "nixos.tests.networking.scripted.dhcpSimple.x86_64-linux"
      "nixos.tests.networking.scripted.loopback.x86_64-linux"
      "nixos.tests.networking.scripted.macvlan.x86_64-linux"
      "nixos.tests.networking.scripted.sit.x86_64-linux"
      "nixos.tests.networking.scripted.static.x86_64-linux"
      "nixos.tests.networking.scripted.vlan.x86_64-linux"
      "nixos.tests.nfs3.simple.x86_64-linux"
      "nixos.tests.nfs4.simple.x86_64-linux"
      "nixos.tests.openssh.x86_64-linux"
      "nixos.tests.pantheon.x86_64-linux"
      "nixos.tests.php-pcre.x86_64-linux"
      "nixos.tests.plasma5.x86_64-linux"
      "nixos.tests.predictable-interface-names.predictableNetworkd.x86_64-linux"
      "nixos.tests.predictable-interface-names.predictable.x86_64-linux"
      "nixos.tests.predictable-interface-names.unpredictableNetworkd.x86_64-linux"
      "nixos.tests.predictable-interface-names.unpredictable.x86_64-linux"
      "nixos.tests.printing.x86_64-linux"
      "nixos.tests.proxy.x86_64-linux"
      "nixos.tests.sddm.default.x86_64-linux"
      "nixos.tests.simple.x86_64-linux"
      "nixos.tests.switchTest.x86_64-linux"
      "nixos.tests.udisks2.x86_64-linux"
      "nixos.tests.xfce.x86_64-linux"
      "nixos.tests.zfs.installer.i686-linux"
      "nixpkgs.emacs.x86_64-linux"
      "nixpkgs.jdk.x86_64-linux"
      "nixpkgs.tarball"
    ];
  };

}
