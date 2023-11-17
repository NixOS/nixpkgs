{ lib
, stdenv
, python3
, callPackage
, recurseIntoAttrs
, nixosTests
, config
, fetchPypi
}:

# To expose the *srht modules, they have to be a python module so we use `buildPythonModule`
# Then we expose them through all-packages.nix as an application through `toPythonApplication`
# https://github.com/NixOS/nixpkgs/pull/54425#discussion_r250688781
let
  python = python3.override {
    packageOverrides = self: super: {
      srht = self.callPackage ./core.nix { };

      buildsrht = self.callPackage ./builds.nix { };
      gitsrht = self.callPackage ./git.nix { };
      hgsrht = self.callPackage ./hg.nix { };
      hubsrht = self.callPackage ./hub.nix { };
      listssrht = self.callPackage ./lists.nix { };
      mansrht = self.callPackage ./man.nix { };
      metasrht = self.callPackage ./meta.nix { };
      pastesrht = self.callPackage ./paste.nix { };
      todosrht = self.callPackage ./todo.nix { };

      scmsrht = self.callPackage ./scm.nix { };

      # sourcehut is not (yet) compatible with SQLAlchemy 2.x
      sqlalchemy = super.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "1.4.46";
        src = fetchPypi {
          pname = "SQLAlchemy";
          inherit version;
          hash = "sha256-aRO4JH2KKS74MVFipRkx4rQM6RaB8bbxj2lwRSAMSjA=";
        };
        nativeCheckInputs = with super; [ pytestCheckHook mock ];
        disabledTestPaths = []
          # Disable incompatible tests on Darwin.
          ++ lib.optionals stdenv.isDarwin [ "test/aaa_profiling" ];
      });

      flask-sqlalchemy = super.flask-sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "2.5.1";
        format = "setuptools";
        src = fetchPypi {
          pname = "Flask-SQLAlchemy";
          inherit version;
          hash = "sha256-K9pEtD58rLFdTgX/PMH4vJeTbMRkYjQkECv8LDXpWRI=";
        };
        propagatedBuildInputs = with self; [
          flask
          sqlalchemy
        ];
      });

      # sourcehut is not (yet) compatible with factory-boy 3.x
      factory-boy = super.factory-boy.overridePythonAttrs (oldAttrs: rec {
        version = "2.12.0";
        src = fetchPypi {
          pname = "factory_boy";
          inherit version;
          hash = "sha256-+vSNYIoXNfDQo8nL9TbWT5EytUfa57pFLE2Zp56Eo3A=";
        };
        nativeCheckInputs = (with super; [
          django
          flask
          mongoengine
          pytestCheckHook
        ]) ++ (with self; [
          sqlalchemy
          flask-sqlalchemy
        ]);
        postPatch = "";
      });
    };
  };
in
with python.pkgs; recurseIntoAttrs ({
  inherit python;
  coresrht = toPythonApplication srht;
  buildsrht = toPythonApplication buildsrht;
  gitsrht = toPythonApplication gitsrht;
  hgsrht = toPythonApplication hgsrht;
  hubsrht = toPythonApplication hubsrht;
  listssrht = toPythonApplication listssrht;
  mansrht = toPythonApplication mansrht;
  metasrht = toPythonApplication metasrht;
  pagessrht = callPackage ./pages.nix { };
  pastesrht = toPythonApplication pastesrht;
  todosrht = toPythonApplication todosrht;
  passthru.tests = {
    nixos-sourcehut = nixosTests.sourcehut;
  };
} // lib.optionalAttrs config.allowAliases {
  # Added 2022-10-29
  dispatchsrht = throw "dispatch is deprecated. See https://sourcehut.org/blog/2022-08-01-dispatch-deprecation-plans/ for more information.";
})
