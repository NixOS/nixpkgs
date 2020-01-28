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

  tested = pkgs.lib.hydraJob (pkgs.releaseTools.aggregate {
    name = "nixos-${nixos.channel.version}";
    meta = {
      description = "Release-critical builds for the NixOS channel";
      maintainers = with pkgs.lib.maintainers; [ eelco fpletz ];
    };
    constituents =
      let
        # Except for the given systems, return the system-specific constituent
        except = systems: x: map (system: x.${system}) (pkgs.lib.subtractLists systems supportedSystems);
        all = x: except [] x;
      in [
        nixos.channel
        (all nixos.dummy)
        (all nixos.manual)

        nixos.iso_plasma5.x86_64-linux or []
        nixos.iso_minimal.aarch64-linux or []
        nixos.iso_minimal.i686-linux or []
        nixos.iso_minimal.x86_64-linux or []
        nixos.ova.x86_64-linux or []
        nixos.sd_image.aarch64-linux or []

        #(all nixos.tests.containers)
        (all nixos.tests.containers-imperative)
        (all nixos.tests.containers-ip)
        nixos.tests.chromium.x86_64-linux or []
        (all nixos.tests.firefox)
        (all nixos.tests.firewall)
        (all nixos.tests.fontconfig-default-fonts)
        (all nixos.tests.gnome3-xorg)
        (all nixos.tests.gnome3)
        (all nixos.tests.pantheon)
        nixos.tests.installer.zfsroot.x86_64-linux or [] # ZFS is 64bit only
        (except ["aarch64-linux"] nixos.tests.installer.lvm)
        (except ["aarch64-linux"] nixos.tests.installer.luksroot)
        (except ["aarch64-linux"] nixos.tests.installer.separateBoot)
        (except ["aarch64-linux"] nixos.tests.installer.separateBootFat)
        (except ["aarch64-linux"] nixos.tests.installer.simple)
        (except ["aarch64-linux"] nixos.tests.installer.simpleLabels)
        (except ["aarch64-linux"] nixos.tests.installer.simpleProvided)
        (except ["aarch64-linux"] nixos.tests.installer.simpleUefiSystemdBoot)
        (except ["aarch64-linux"] nixos.tests.installer.swraid)
        (except ["aarch64-linux"] nixos.tests.installer.btrfsSimple)
        (except ["aarch64-linux"] nixos.tests.installer.btrfsSubvols)
        (except ["aarch64-linux"] nixos.tests.installer.btrfsSubvolDefault)
        (except ["aarch64-linux"] nixos.tests.boot.biosCdrom)
        #(except ["aarch64-linux"] nixos.tests.boot.biosUsb) # disabled due to issue #15690
        (except ["aarch64-linux"] nixos.tests.boot.uefiCdrom)
        (except ["aarch64-linux"] nixos.tests.boot.uefiUsb)
        (all nixos.tests.boot-stage1)
        (all nixos.tests.hibernate)
        nixos.tests.docker.x86_64-linux or []
        (all nixos.tests.ecryptfs)
        (all nixos.tests.env)
        (all nixos.tests.ipv6)
        (all nixos.tests.i3wm)
        # 2018-06-06: keymap tests temporarily removed from tested job
        # since non-deterministic failure are blocking the channel (#41538)
        #(all nixos.tests.keymap.azerty)
        #(all nixos.tests.keymap.colemak)
        #(all nixos.tests.keymap.dvorak)
        #(all nixos.tests.keymap.dvp)
        #(all nixos.tests.keymap.neo)
        #(all nixos.tests.keymap.qwertz)
        (all nixos.tests.plasma5)
        (all nixos.tests.lightdm)
        (all nixos.tests.login)
        (all nixos.tests.misc)
        (all nixos.tests.mutableUsers)
        (all nixos.tests.nat.firewall)
        (all nixos.tests.nat.firewall-conntrack)
        (all nixos.tests.nat.standalone)
        (all nixos.tests.networking.scripted.loopback)
        (all nixos.tests.networking.scripted.static)
        (all nixos.tests.networking.scripted.dhcpSimple)
        (all nixos.tests.networking.scripted.dhcpOneIf)
        (all nixos.tests.networking.scripted.bond)
        (all nixos.tests.networking.scripted.bridge)
        (all nixos.tests.networking.scripted.macvlan)
        (all nixos.tests.networking.scripted.sit)
        (all nixos.tests.networking.scripted.vlan)
        (all nixos.tests.nfs3.simple)
        (all nixos.tests.nfs4.simple)
        (all nixos.tests.openssh)
        (all nixos.tests.php-pcre)
        (all nixos.tests.predictable-interface-names.predictable)
        (all nixos.tests.predictable-interface-names.unpredictable)
        (all nixos.tests.predictable-interface-names.predictableNetworkd)
        (all nixos.tests.predictable-interface-names.unpredictableNetworkd)
        (all nixos.tests.printing)
        (all nixos.tests.proxy)
        (all nixos.tests.sddm.default)
        (all nixos.tests.simple)
        (all nixos.tests.switchTest)
        (all nixos.tests.udisks2)
        (all nixos.tests.xfce)

        nixpkgs.tarball
        (all allSupportedNixpkgs.emacs)
        # The currently available aarch64 JDK is unfree
        (except ["aarch64-linux"] allSupportedNixpkgs.jdk)
      ];
  });

}
