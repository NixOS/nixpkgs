{ nixosTests
, pkgs
, poetry2nix
, lib
, overrides ? (self: super: {})
}:

let

  interpreter = (
    poetry2nix.mkPoetryPackages {
      projectDir = ./.;
      python = pkgs.python310;
      overrides = [
        poetry2nix.defaultPoetryOverrides
        (import ./poetry-git-overlay.nix { inherit pkgs; })
        (
          self: super: {

            nixops = super.nixops.overridePythonAttrs (
              old: {
                version = "${old.version}-pre-${lib.substring 0 7 super.nixops.src.rev or "dirty"}";

                postPatch = ''
                  substituteInPlace nixops/args.py --subst-var version
                '';

                meta = old.meta // {
                  homepage = "https://github.com/NixOS/nixops";
                  description = "NixOS cloud provisioning and deployment tool";
                  maintainers = with lib.maintainers; [ adisbladis aminechikhaoui eelco rob domenkozar ];
                  platforms = lib.platforms.unix;
                  license = lib.licenses.lgpl3;
                };

              }
            );
          }
        )

        # User provided overrides
        overrides

        # Make nixops pluginable
        (self: super: let
          # Create a fake sphinx directory that doesn't pull the entire setup hook and incorrect python machinery
          sphinx = pkgs.runCommand "sphinx" {} ''
            mkdir -p $out/bin
            for f in ${pkgs.python3.pkgs.sphinx}/bin/*; do
              ln -s $f $out/bin/$(basename $f)
            done
          '';

        in {
          nixops = super.__toPluginAble {
            drv = super.nixops;
            finalDrv = self.nixops;

            nativeBuildInputs = [ sphinx ];

            postInstall = ''
              doc_cache=$(mktemp -d)
              sphinx-build -b man -d $doc_cache doc/ $out/share/man/man1

              html=$(mktemp -d)
              sphinx-build -b html -d $doc_cache doc/ $out/share/nixops/doc
            '';

          };
        })

      ];
    }
  ).python;

  pkg = interpreter.pkgs.nixops.withPlugins(ps: [
    ps.nixops-aws
    ps.nixops-digitalocean
    ps.nixops-encrypted-links
    ps.nixops-gcp
    ps.nixops-hercules-ci
    ps.nixops-hetzner
    ps.nixopsvbox
    ps.nixops-virtd
    ps.nixops-hetznercloud
  ]) // rec {
    # Workaround for https://github.com/NixOS/nixpkgs/issues/119407
    # TODO after #1199407: Use .overrideAttrs(pkg: old: { passthru.tests = .....; })
    tests = nixosTests.nixops.unstable.override { nixopsPkg = pkg; };
    # Not strictly necessary, but probably expected somewhere; part of the workaround:
    passthru.tests = tests;
  };
in pkg
