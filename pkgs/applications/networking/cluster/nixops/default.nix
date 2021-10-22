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
      overrides = [
        poetry2nix.defaultPoetryOverrides
        (import ./poetry-git-overlay.nix { inherit pkgs; })
        (
          self: super: {

            nixops = super.nixops.overridePythonAttrs (
              old: {
                postPatch = ''
                  substituteInPlace nixops/args.py --subst-var version
                '';

                meta = old.meta // {
                  homepage = https://github.com/NixOS/nixops;
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
        (self: super: {
          nixops = super.__toPluginAble {
            drv = super.nixops;
            finalDrv = self.nixops;

            nativeBuildInputs = [ self.sphinx ];
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
    ps.nixops-encrypted-links
    ps.nixops-hercules-ci
    ps.nixops-virtd
    ps.nixops-aws
    ps.nixops-gcp
    ps.nixopsvbox
  ]) // rec {
    # Workaround for https://github.com/NixOS/nixpkgs/issues/119407
    # TODO after #1199407: Use .overrideAttrs(pkg: old: { passthru.tests = .....; })
    tests = nixosTests.nixops.unstable.override { nixopsPkg = pkg; };
    # Not strictly necessary, but probably expected somewhere; part of the workaround:
    passthru.tests = tests;
  };
in pkg
