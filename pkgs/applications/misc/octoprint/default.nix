{ pkgs, stdenv, lib, fetchFromGitHub, python3
# To include additional plugins, pass them here as an overlay.
, packageOverrides ? self: super: {}
}:
let
  mkOverride = attrname: version: sha256:
    self: super: {
      ${attrname} = super.${attrname}.overridePythonAttrs (oldAttrs: {
        inherit version;
        src = oldAttrs.src.override {
          inherit version sha256;
        };
      });
    };

  py = python3.override {
    self = py;
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) ([
      (mkOverride "flask"       "0.12.5" "fac2b9d443e49f7e7358a444a3db5950bdd0324674d92ba67f8f1f15f876b14f")
      (mkOverride "flaskbabel"  "0.12.2" "11jwp8vvq1gnm31qh6ihy2h393hy18yn9yjp569g60r0wj1x2sii")
      (mkOverride "tornado"     "4.5.3"  "02jzd23l4r6fswmwxaica9ldlyc2p6q8dk6dyff7j58fmdzf853d")
      (mkOverride "psutil"      "5.6.7"  "ffad8eb2ac614518bbe3c0b8eb9dffdb3a8d2e3a7d5da51c5b974fb723a5c5aa")
      (mkOverride "watchdog"    "0.9.0"  "07cnvvlpif7a6cg4rav39zq8fxa5pfqawchr46433pij0y6napwn")

      # Octoprint holds back jinja2 to 2.8.1 due to breaking changes.
      # This old version does not have updated test config for pytest 4,
      # and pypi tarball doesn't contain tests dir anyways.
      (self: super: {
        jinja2 = super.jinja2.overridePythonAttrs (oldAttrs: rec {
          version = "2.8.1";
          src = oldAttrs.src.override {
            inherit version;
            sha256 = "14aqmhkc9rw5w0v311jhixdm6ym8vsm29dhyxyrjfqxljwx1yd1m";
          };
          doCheck = false;
        });

        httpretty = super.httpretty.overridePythonAttrs (oldAttrs: rec {
          doCheck = false;
        });

        celery = super.celery.overridePythonAttrs (oldAttrs: rec {
          doCheck = false;
        });
      })
      (self: super: {
        octoprint = self.buildPythonPackage rec {
          pname = "OctoPrint";
          version = "1.4.0";

          src = fetchFromGitHub {
            owner  = "foosel";
            repo   = "OctoPrint";
            rev    = version;
            sha256 = "0387228544v28d69dcdg2zr5gp6qavkfr6dydpjgj5awxv3w25d5";
          };

          propagatedBuildInputs = with super; [
            awesome-slugify flask flask_assets rsa requests pkginfo watchdog
            semantic-version werkzeug flaskbabel tornado
            psutil pyserial flask_login netaddr markdown
            pylru pyyaml sarge feedparser netifaces click websocket_client
            scandir chainmap future wrapt monotonic emoji jinja2
            frozendict cachelib sentry-sdk filetype markupsafe
          ] ++ lib.optionals stdenv.isDarwin [ py.pkgs.appdirs ];

          checkInputs = with super; [ pytestCheckHook mock ddt ];

          postPatch = let
            ignoreVersionConstraints = [
              "sentry-sdk"
            ];
          in ''
            sed -r -i \
              ${lib.concatStringsSep "\n" (map (e:
                ''-e 's@${e}[<>=]+.*@${e}",@g' \''
              ) ignoreVersionConstraints)}
              setup.py
          '';

          dontUseSetuptoolsCheck = true;

          preCheck = ''
            export HOME=$(mktemp -d)
            rm pytest.ini
          '';

          disabledTests = [
            "test_check_setup" # Why should it be able to call pip?
          ] ++ lib.optionals stdenv.isDarwin [
            "test_set_external_modification"
          ];

          passthru.python = self.python;

          meta = with stdenv.lib; {
            homepage = "https://octoprint.org/";
            description = "The snappy web interface for your 3D printer";
            license = licenses.agpl3;
            maintainers = with maintainers; [ abbradar gebner WhittlesJr ];
          };
        };
      })
      (import ./plugins.nix {inherit pkgs;})
      packageOverrides
    ]);
  };
in with py.pkgs; toPythonApplication octoprint
