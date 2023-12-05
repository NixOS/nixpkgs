{ python3 }:

let
  python = python3.override {
    packageOverrides = self: super: {
      nixops = self.callPackage ./unwrapped.nix { };
    } // (plugins self);
  };

  plugins = ps: with ps; rec {
    nixops-aws = callPackage ./plugins/nixops-aws.nix { };
    nixops-digitalocean = callPackage ./plugins/nixops-digitalocean.nix { };
    nixops-encrypted-links = callPackage ./plugins/nixops-encrypted-links.nix { };
    nixops-gce = callPackage ./plugins/nixops-gce.nix { };
    nixops-hercules-ci = callPackage ./plugins/nixops-hercules-ci.nix { };
    nixops-hetzner = callPackage ./plugins/nixops-hetzner.nix { };
    nixops-hetznercloud = callPackage ./plugins/nixops-hetznercloud.nix { };
    nixops-libvirtd = callPackage ./plugins/nixops-libvirtd.nix { };
    nixops-vbox = callPackage ./plugins/nixops-vbox.nix { };
    nixos-modules-contrib = callPackage ./plugins/nixos-modules-contrib.nix { };

    # aliases for backwards compatibility
    nixops-gcp = nixops-gce;
    nixops-virtd = nixops-libvirtd;
    nixopsvbox = nixops-vbox;
  };

  # selector is a function mapping pythonPackages to a list of plugins
  # e.g. nixops_unstable.withPlugins (ps: with ps; [ nixops-aws ])
  withPlugins = selector: let
    selected = selector (plugins python.pkgs);
  in python.pkgs.toPythonApplication (python.pkgs.nixops.overridePythonAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ selected;

    # Propagating dependencies leaks them through $PYTHONPATH which causes issues
    # when used in nix-shell.
    postFixup = ''
      rm $out/nix-support/propagated-build-inputs
    '';

    passthru = old.passthru // {
      plugins = plugins python.pkgs;
      inherit withPlugins python;
    };
  }));
in withPlugins (ps: [
  ps.nixops-aws
  ps.nixops-digitalocean
  ps.nixops-encrypted-links
  ps.nixops-gce
  ps.nixops-hercules-ci
  ps.nixops-hetzner
  ps.nixops-hetznercloud
  ps.nixops-libvirtd
  ps.nixops-vbox
])
