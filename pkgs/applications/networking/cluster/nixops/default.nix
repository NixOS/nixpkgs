{ lib, python3 }:

let
  inherit (lib) extends;

  # doc: https://github.com/NixOS/nixpkgs/pull/158781/files#diff-854251fa1fe071654921224671c8ba63c95feb2f96b2b3a9969c81676780053a
  encapsulate = layerZero:
    let
      fixed = layerZero ({ extend = f: encapsulate (extends f layerZero); } // fixed);
    in fixed.public;

  nixopsContextBase = this: {

    python = python3.override {
      packageOverrides = self: super: {
        nixops = self.callPackage ./unwrapped.nix { };
      } // (this.plugins self);
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

    availablePlugins = this.plugins this.python.pkgs;

    selectedPlugins = [];

    # selector is a function mapping pythonPackages to a list of plugins
    # e.g. nixops_unstable.withPlugins (ps: with ps; [ nixops-aws ])
    withPlugins = selector:
      this.extend (this: _old: {
        selectedPlugins = selector this.availablePlugins;
      });

    rawPackage =
      let
        r = this.python.pkgs.toPythonApplication (this.python.pkgs.nixops.overridePythonAttrs (old: {
          propagatedBuildInputs = old.propagatedBuildInputs ++ this.selectedPlugins;

          # Propagating dependencies leaks them through $PYTHONPATH which causes issues
          # when used in nix-shell.
          postFixup = ''
            rm $out/nix-support/propagated-build-inputs
          '';

          passthru = old.passthru // {
            inherit (this) selectedPlugins availablePlugins withPlugins python;
            tests = old.passthru.tests // {
              nixos = old.passthru.tests.nixos.passthru.override {
                nixopsPkg = r;
              };
            }
              # Make sure we also test with a configuration that's been extended with a plugin.
              // lib.optionalAttrs (this.selectedPlugins == [ ]) {
              withAPlugin =
                lib.recurseIntoAttrs
                  (this.withPlugins (ps: with ps; [ nixops-encrypted-links ])).tests;
            };
          };
        }));
      in
      r;

    public = this.rawPackage;
  };

  minimal = encapsulate nixopsContextBase;

in
{
  nixops_unstable_minimal = minimal;

  # Not recommended; too fragile.
  nixops_unstable_full = minimal.withPlugins (ps: [
    ps.nixops-aws
    ps.nixops-digitalocean
    ps.nixops-encrypted-links
    ps.nixops-gce
    ps.nixops-hercules-ci
    ps.nixops-hetzner
    ps.nixops-hetznercloud
    ps.nixops-libvirtd
    ps.nixops-vbox
  ]);
}
