{
  lib,
  python3,
  callPackage,
  recurseIntoAttrs,
  nixosTests,
  config,
  fetchPypi,
  fetchpatch,
}:

# To expose the *srht modules, they have to be a python module so we use `buildPythonModule`
# Then we expose them through all-packages.nix as an application through `toPythonApplication`
# https://github.com/NixOS/nixpkgs/pull/54425#discussion_r250688781
let
  python = python3.override {
    self = python;
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
      sqlalchemy = super.sqlalchemy_1_4;

      # sourcehut is not (yet) compatible with flask-sqlalchemy 3.x
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
        disabledTests = [ "test_persist_selectable" ];
      });

      # flask-sqlalchemy 2.x requires flask 2.x
      flask = super.flask.overridePythonAttrs (oldAttrs: rec {
        version = "2.3.3";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-CcNHqSqn/0qOfzIGeV8w2CZlS684uHPQdEzVccpgnvw=";
        };
      });

      # flask 2.x requires werkzeug 2.x
      werkzeug = super.werkzeug.overridePythonAttrs (oldAttrs: rec {
        version = "2.3.8";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-VUslfHS763oNJUFgpPj/4YUkP1KlIDUGC3Ycpi2XfwM=";
        };
        # Fixes a test failure with Pytest 8
        patches = (oldAttrs.patches or [ ]) ++ [
          (fetchpatch {
            url = "https://github.com/pallets/werkzeug/commit/4e5bdca7f8227d10cae828f8064fb98190ace4aa.patch";
            hash = "sha256-83doVvfdpymlAB0EbfrHmuoKE5B2LJbFq+AY2xGpnl4=";
          })
        ];
        nativeCheckInputs = oldAttrs.nativeCheckInputs or [ ] ++ [ self.pytest-xprocess ];
      });

      # sourcehut is not (yet) compatible with factory-boy 3.x
      factory-boy = super.factory-boy.overridePythonAttrs (oldAttrs: rec {
        version = "2.12.0";
        src = fetchPypi {
          pname = "factory_boy";
          inherit version;
          hash = "sha256-+vSNYIoXNfDQo8nL9TbWT5EytUfa57pFLE2Zp56Eo3A=";
        };
        nativeCheckInputs =
          (with super; [
            django
            mongoengine
            pytestCheckHook
          ])
          ++ (with self; [
            sqlalchemy
            flask
            flask-sqlalchemy
          ]);
        postPatch = "";
      });
    };
  };
in
with python.pkgs;
recurseIntoAttrs (
  {
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
  }
  // lib.optionalAttrs config.allowAliases {
    # Added 2022-10-29
    dispatchsrht = throw "dispatch is deprecated. See https://sourcehut.org/blog/2022-08-01-dispatch-deprecation-plans/ for more information.";
  }
)
