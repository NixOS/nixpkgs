# This jobset defines the main NixOS channels (such as nixos-unstable
# and nixos-14.04). The channel is updated every time the ‘tested’ job
# succeeds, and all other jobs have finished (they may fail).

{
  nixpkgs ? {
    outPath = (import ../lib).cleanSource ./..;
    revCount = 56789;
    shortRev = "gfedcba";
  },
  stableBranch ? false,
  supportedSystems ? [
    "aarch64-linux"
    "x86_64-linux"
  ],
  limitedSupportedSystems ? [ ],
}:

let

  nixpkgsSrc = nixpkgs; # urgh

  pkgs = import ./.. { };

  removeMaintainers =
    set:
    if builtins.isAttrs set then
      if (set.type or "") == "derivation" then
        set // { meta = builtins.removeAttrs (set.meta or { }) [ "maintainers" ]; }
      else
        pkgs.lib.mapAttrs (n: v: removeMaintainers v) set
    else
      set;

in
rec {

  nixos = removeMaintainers (
    import ./release.nix {
      inherit stableBranch;
      supportedSystems = supportedSystems ++ limitedSupportedSystems;
      nixpkgs = nixpkgsSrc;
    }
  );

  nixpkgs = builtins.removeAttrs (removeMaintainers (
    import ../pkgs/top-level/release.nix {
      inherit supportedSystems;
      nixpkgs = nixpkgsSrc;
    }
  )) [ "unstable" ];

  tested =
    let
      onFullSupported = x: map (system: "${x}.${system}") supportedSystems;
      onAllSupported = x: map (system: "${x}.${system}") (supportedSystems ++ limitedSupportedSystems);
      onSystems =
        systems: x:
        map (system: "${x}.${system}") (
          pkgs.lib.intersectLists systems (supportedSystems ++ limitedSupportedSystems)
        );
    in
    pkgs.releaseTools.aggregate {
      name = "nixos-${nixos.channel.version}";
      meta = {
        description = "Release-critical builds for the NixOS channel";
        maintainers = [ ];
      };
      constituents = pkgs.lib.concatLists [
        [ "nixos.channel" ]
        (onFullSupported "nixos.dummy")
        (onAllSupported "nixos.iso_minimal")
        (onSystems [ "x86_64-linux" "aarch64-linux" ] "nixos.amazonImage")
        (onFullSupported "nixos.iso_graphical")
        (onFullSupported "nixos.manual")
        (onSystems [ "aarch64-linux" ] "nixos.sd_image")
        (onFullSupported "nixos.tests.acme.http01-builtin")
        (onFullSupported "nixos.tests.acme.dns01")
        (onSystems [ "x86_64-linux" ] "nixos.tests.boot.biosCdrom")
        (onSystems [ "x86_64-linux" ] "nixos.tests.boot.biosUsb")
        (onFullSupported "nixos.tests.boot-stage1")
        (onFullSupported "nixos.tests.boot.uefiCdrom")
        (onFullSupported "nixos.tests.boot.uefiUsb")
        (onFullSupported "nixos.tests.chromium")
        (onFullSupported "nixos.tests.containers-imperative")
        (onFullSupported "nixos.tests.containers-ip")
        (onSystems [ "x86_64-linux" ] "nixos.tests.docker")
        (onFullSupported "nixos.tests.env")

        # Way too many manual retries required on Hydra.
        #  Apparently it's hard to track down the cause.
        #  So let's depend just on the packages for now.
        #(onFullSupported "nixos.tests.firefox-esr")
        #(onFullSupported "nixos.tests.firefox")
        # Note: only -unwrapped variants have a Hydra job.
        (onFullSupported "nixpkgs.firefox-esr-unwrapped")
        (onFullSupported "nixpkgs.firefox-unwrapped")

        (onFullSupported "nixos.tests.firewall")
        (onFullSupported "nixos.tests.fontconfig-default-fonts")
        (onFullSupported "nixos.tests.gitlab")
        (onFullSupported "nixos.tests.gnome")
        (onSystems [ "x86_64-linux" ] "nixos.tests.hibernate")
        (onFullSupported "nixos.tests.i3wm")
        (onSystems [ "aarch64-linux" ] "nixos.tests.installer.simpleUefiSystemdBoot")
        (onSystems [ "x86_64-linux" ] "nixos.tests.installer.btrfsSimple")
        (onSystems [ "x86_64-linux" ] "nixos.tests.installer.btrfsSubvolDefault")
        (onSystems [ "x86_64-linux" ] "nixos.tests.installer.btrfsSubvolEscape")
        (onSystems [ "x86_64-linux" ] "nixos.tests.installer.btrfsSubvols")
        (onSystems [ "x86_64-linux" ] "nixos.tests.installer.luksroot")
        (onSystems [ "x86_64-linux" ] "nixos.tests.installer.lvm")
        (onSystems [ "x86_64-linux" ] "nixos.tests.installer.separateBootZfs")
        (onSystems [ "x86_64-linux" ] "nixos.tests.installer.separateBootFat")
        (onSystems [ "x86_64-linux" ] "nixos.tests.installer.separateBoot")
        (onSystems [ "x86_64-linux" ] "nixos.tests.installer.simpleLabels")
        (onSystems [ "x86_64-linux" ] "nixos.tests.installer.simpleProvided")
        (onSystems [ "x86_64-linux" ] "nixos.tests.installer.simpleUefiSystemdBoot")
        (onSystems [ "x86_64-linux" ] "nixos.tests.installer.simple")
        (onSystems [ "x86_64-linux" ] "nixos.tests.installer.swraid")
        (onSystems [ "x86_64-linux" ] "nixos.tests.installer.zfsroot")
        (onSystems [ "x86_64-linux" ] "nixos.tests.nixos-rebuild-specialisations")
        (onFullSupported "nixos.tests.nix-misc.default")
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
        (onFullSupported "nixos.tests.networking.scripted.sit-fou")
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
        (onFullSupported "nixos.tests.networking.networkd.sit-fou")
        (onFullSupported "nixos.tests.networking.networkd.static")
        (onFullSupported "nixos.tests.networking.networkd.virtual")
        (onFullSupported "nixos.tests.networking.networkd.vlan")
        (onFullSupported "nixos.tests.systemd-networkd-ipv6-prefix-delegation")
        (onFullSupported "nixos.tests.nfs4.simple")
        (onSystems [ "x86_64-linux" ] "nixos.tests.oci-containers.podman")
        (onFullSupported "nixos.tests.openssh")
        (onFullSupported "nixos.tests.initrd-network-ssh")
        (onFullSupported "nixos.tests.pantheon")
        (onFullSupported "nixos.tests.php.fpm")
        (onFullSupported "nixos.tests.php.httpd")
        (onFullSupported "nixos.tests.php.pcre")
        (onFullSupported "nixos.tests.plasma6")
        (onSystems [ "x86_64-linux" ] "nixos.tests.podman")
        (onFullSupported "nixos.tests.predictable-interface-names.predictableNetworkd")
        (onFullSupported "nixos.tests.predictable-interface-names.predictable")
        (onFullSupported "nixos.tests.predictable-interface-names.unpredictableNetworkd")
        (onFullSupported "nixos.tests.predictable-interface-names.unpredictable")
        (onFullSupported "nixos.tests.printing-service")
        (onFullSupported "nixos.tests.printing-socket")
        (onFullSupported "nixos.tests.proxy")
        (onFullSupported "nixos.tests.sddm.default")
        (onFullSupported "nixos.tests.shadow")
        (onFullSupported "nixos.tests.simple")
        (onFullSupported "nixos.tests.sway")
        (onFullSupported "nixos.tests.switchTest")
        (onFullSupported "nixos.tests.udisks2")
        (onFullSupported "nixos.tests.xfce")
        (onFullSupported "nixpkgs.emacs")
        (onFullSupported "nixpkgs.jdk")
        (onSystems [ "x86_64-linux" ] "nixpkgs.mesa_i686") # i686 sanity check + useful
        [
          "nixpkgs.tarball"
          "nixpkgs.release-checks"
        ]
      ];
    };
}
