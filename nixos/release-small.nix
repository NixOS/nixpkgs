# This jobset is used to generate a NixOS channel that contains a
# small subset of Nixpkgs, mostly useful for servers that need fast
# security updates.

{ nixpkgs ? { outPath = ./..; revCount = 56789; shortRev = "gfedcba"; }
, stableBranch ? false
, supportedSystems ? [ "x86_64-linux" ] # no i686-linux
}:

let

  nixpkgsSrc = nixpkgs; # urgh

  pkgs = import ./.. {};

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
    inherit (nixos') channel manual iso_minimal dummy;
    tests = {
      inherit (nixos'.tests)
        containers-imperative
        containers-ipv4
        firewall
        ipv6
        login
        misc
        nat
        nfs3
        openssh
        proxy
        simple;
      installer = {
        inherit (nixos'.tests.installer)
          lvm
          separateBoot
          simple;
      };
    };
  };

  nixpkgs = {
    inherit (nixpkgs')
      apacheHttpd_2_2
      apacheHttpd_2_4
      cmake
      cryptsetup
      emacs
      gettext
      git
      imagemagick
      jdk
      linux
      mysql55
      nginx
      nodejs
      openssh
      php
      postgresql92
      postgresql93
      python
      rsyslog
      stdenv
      subversion
      tarball
      vim;
  };

  tested = lib.hydraJob (pkgs.releaseTools.aggregate {
    name = "nixos-${nixos.channel.version}";
    meta = {
      description = "Release-critical builds for the NixOS channel";
      maintainers = [ lib.maintainers.eelco ];
    };
    constituents =
      let all = x: map (system: x.${system}) supportedSystems; in
      [ nixpkgs.tarball
        (all nixpkgs.jdk)
      ]
      ++ lib.collect lib.isDerivation nixos;
  });

}
