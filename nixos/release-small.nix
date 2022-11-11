# This jobset is used to generate a NixOS channel that contains a
# small subset of Nixpkgs, mostly useful for servers that need fast
# security updates.

{ nixpkgs ? { outPath = (import ../lib).cleanSource ./..; revCount = 56789; shortRev = "gfedcba"; }
, stableBranch ? false
, supportedSystems ? [ "aarch64-linux" "x86_64-linux" ] # no i686-linux
}:

let

  nixpkgsSrc = nixpkgs; # urgh

  pkgs = import ./.. { system = "x86_64-linux"; };

  lib = pkgs.lib;

  nixos' = import ./release.nix {
    inherit stableBranch supportedSystems;
    nixpkgs = nixpkgsSrc;
  };

  nixpkgs' = builtins.removeAttrs (import ../pkgs/top-level/release.nix {
    inherit supportedSystems;
    nixpkgs = nixpkgsSrc;
  }) [ "unstable" ];

in rec {

  nixos = {
    inherit (nixos') channel manual options iso_minimal amazonImage dummy;
    tests = {
      inherit (nixos'.tests)
        acme
        containers-imperative
        containers-ip
        firewall
        ipv6
        login
        misc
        nat
        # fails with kernel >= 5.15 https://github.com/NixOS/nixpkgs/pull/152505#issuecomment-1005049314
        #nfs3
        openssh
        php
        predictable-interface-names
        proxy
        simple;
      installer = {
        inherit (nixos'.tests.installer)
          lvm
          separateBoot
          simple;
      };
      boot = {
        inherit (nixos'.tests.boot)
          biosCdrom
          uefiCdrom;
      };
    };
  };

  nixpkgs = {
    inherit (nixpkgs')
      apacheHttpd
      cmake
      cryptsetup
      emacs
      gettext
      git
      imagemagick
      jdk
      linux
      mariadb
      nginx
      nodejs
      openssh
      php
      postgresql
      python
      rsyslog
      stdenv
      subversion
      tarball
      vim;
  };

  tested = let
    onSupported = x: map (system: "${x}.${system}") supportedSystems;
    onSystems = systems: x: map (system: "${x}.${system}")
      (pkgs.lib.intersectLists systems supportedSystems);
  in pkgs.releaseTools.aggregate {
    name = "nixos-${nixos.channel.version}";
    meta = {
      description = "Release-critical builds for the NixOS channel";
      maintainers = [ lib.maintainers.eelco ];
    };
    constituents = lib.flatten [
      [
        "nixos.channel"
        "nixpkgs.tarball"
      ]
      (map (onSystems [ "x86_64-linux" ]) [
        "nixos.tests.boot.biosCdrom"
        "nixos.tests.installer.lvm"
        "nixos.tests.installer.separateBoot"
        "nixos.tests.installer.simple"
      ])
      (map onSupported [
        "nixos.dummy"
        "nixos.iso_minimal"
        "nixos.amazonImage"
        "nixos.manual"
        "nixos.tests.acme"
        "nixos.tests.boot.uefiCdrom"
        "nixos.tests.containers-imperative"
        "nixos.tests.containers-ip"
        "nixos.tests.firewall"
        "nixos.tests.ipv6"
        "nixos.tests.login"
        "nixos.tests.misc"
        "nixos.tests.nat.firewall-conntrack"
        "nixos.tests.nat.firewall"
        "nixos.tests.nat.standalone"
        # fails with kernel >= 5.15 https://github.com/NixOS/nixpkgs/pull/152505#issuecomment-1005049314
        #"nixos.tests.nfs3.simple"
        "nixos.tests.openssh"
        "nixos.tests.php.fpm"
        "nixos.tests.php.pcre"
        "nixos.tests.predictable-interface-names.predictable"
        "nixos.tests.predictable-interface-names.predictableNetworkd"
        "nixos.tests.predictable-interface-names.unpredictable"
        "nixos.tests.predictable-interface-names.unpredictableNetworkd"
        "nixos.tests.proxy"
        "nixos.tests.simple"
        "nixpkgs.jdk"
      ])
    ];
  };

}
