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
    inherit (nixos') channel manual options iso_minimal amazonImage dummy;
    tests = {
      inherit (nixos'.tests)
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
      [ "nixos.channel"
        "nixos.dummy.x86_64-linux"
        "nixos.iso_minimal.x86_64-linux"
        "nixos.amazonImage.x86_64-linux"
        "nixos.manual.x86_64-linux"
        "nixos.tests.boot.biosCdrom.x86_64-linux"
        "nixos.tests.containers-imperative.x86_64-linux"
        "nixos.tests.containers-ip.x86_64-linux"
        "nixos.tests.firewall.x86_64-linux"
        "nixos.tests.installer.lvm.x86_64-linux"
        "nixos.tests.installer.separateBoot.x86_64-linux"
        "nixos.tests.installer.simple.x86_64-linux"
        "nixos.tests.ipv6.x86_64-linux"
        "nixos.tests.login.x86_64-linux"
        "nixos.tests.misc.x86_64-linux"
        "nixos.tests.nat.firewall-conntrack.x86_64-linux"
        "nixos.tests.nat.firewall.x86_64-linux"
        "nixos.tests.nat.standalone.x86_64-linux"
        # fails with kernel >= 5.15 https://github.com/NixOS/nixpkgs/pull/152505#issuecomment-1005049314
        #"nixos.tests.nfs3.simple.x86_64-linux"
        "nixos.tests.openssh.x86_64-linux"
        "nixos.tests.php.fpm.x86_64-linux"
        "nixos.tests.php.pcre.x86_64-linux"
        "nixos.tests.predictable-interface-names.predictable.x86_64-linux"
        "nixos.tests.predictable-interface-names.predictableNetworkd.x86_64-linux"
        "nixos.tests.predictable-interface-names.unpredictable.x86_64-linux"
        "nixos.tests.predictable-interface-names.unpredictableNetworkd.x86_64-linux"
        "nixos.tests.proxy.x86_64-linux"
        "nixos.tests.simple.x86_64-linux"
        "nixpkgs.jdk.x86_64-linux"
        "nixpkgs.tarball"
      ];
  };

}
