# This jobset is used to generate a NixOS channel that contains a
# small subset of Nixpkgs, mostly useful for servers that need fast
# security updates.

{ nixpkgs ? { outPath = (import ../lib).cleanSource ./..; revCount = 56789; shortRev = "gfedcba"; }
, stableBranch ? false
, supportedSystems ? [ "x86_64-linux" ] # no i686-linux
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
    inherit (nixos') channel manual options iso_minimal dummy;
    tests = {
      inherit (nixos'.tests)
        containers-imperative
        containers-ipv4
        containers-ipv6
        firewall
        ipv6
        login
        misc
        nat
        nfs3
        openssh
        php-pcre
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
          biosCdrom;
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
      mysql
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

  tested = pkgs.releaseTools.aggregate {
    name = "nixos-${nixos.channel.version}";
    meta = {
      description = "Release-critical builds for the NixOS channel";
      maintainers = [ lib.maintainers.eelco ];
    };
    constituents =
      let all = x: map (system: x + ".${system}") supportedSystems; in
      lib.flatten [
        "nixpkgs.tarball"
        (all "nixpkgs.jdk")
        "nixos.channel"
        "nixos.manual.x86_64-linux"
        (all "nixos.iso_minimal")
        (all "nixos.dummy")
        (all "nixos.tests.containers-imperative")
        (all "nixos.tests.containers-ipv4")
        (all "nixos.tests.containers-ipv6")
        (all "nixos.tests.firewall")
        (all "nixos.tests.ipv6")
        (all "nixos.tests.login")
        (all "nixos.tests.misc")
        (all "nixos.tests.nat.firewall-conntrack")
        (all "nixos.tests.nat.firewall")
        (all "nixos.tests.nat.standalone")
        (all "nixos.tests.nfs3")
        (all "nixos.tests.openssh")
        (all "nixos.tests.php-pcre")
        (all "nixos.tests.predictable-interface-names.predictable")
        (all "nixos.tests.predictable-interface-names.predictableNetworkd")
        (all "nixos.tests.predictable-interface-names.unpredictable")
        (all "nixos.tests.predictable-interface-names.unpredictableNetworkd")
        (all "nixos.tests.proxy")
        (all "nixos.tests.simple")
        (all "nixos.tests.installer.lvm")
        (all "nixos.tests.installer.separateBoot")
        (all "nixos.tests.installer.simple")
        (all "nixos.tests.boot.biosCdrom")
      ];
  };

}
