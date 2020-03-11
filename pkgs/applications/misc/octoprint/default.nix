{ stdenv, lib, fetchFromGitHub, python3 }:
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
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) ([
      (mkOverride "flask"       "0.12.5" "fac2b9d443e49f7e7358a444a3db5950bdd0324674d92ba67f8f1f15f876b14f")
      (mkOverride "tornado"     "4.5.3"  "02jzd23l4r6fswmwxaica9ldlyc2p6q8dk6dyff7j58fmdzf853d")
      (mkOverride "psutil"      "5.6.7"  "ffad8eb2ac614518bbe3c0b8eb9dffdb3a8d2e3a7d5da51c5b974fb723a5c5aa")

      # Octoprint holds back jinja2 to 2.8.1 due to breaking changes.
      # This old version does not have updated test config for pytest 4,
      # and pypi tarball doesn't contain tests dir anyways.
      (pself: psuper: {
        sentry-sdk = psuper.sentry-sdk.overridePythonAttrs (oldAttrs: rec {
          version = "0.13.2";
          src = oldAttrs.src.override {
            inherit version;
            sha256 = "ff1fa7fb85703ae9414c8b427ee73f8363232767c9cd19158f08f6e4f0b58fc7";
          };
          checkInputs = with pself; [flask bottle falcon];
        });

        jinja2 = psuper.jinja2.overridePythonAttrs (oldAttrs: rec {
          version = "2.8.1";
          src = oldAttrs.src.override {
            inherit version;
            sha256 = "14aqmhkc9rw5w0v311jhixdm6ym8vsm29dhyxyrjfqxljwx1yd1m";
          };
          doCheck = false;
        });
      })
    ]);
  };

in
py.pkgs.buildPythonApplication rec {
  pname = "OctoPrint";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner  = "foosel";
    repo   = "OctoPrint";
    rev    = version;
    sha256 = "1zla1ayr62lkvkr828dh3y287rzj3rv1hpij9kws44ynn4i582ga";
  };

  propagatedBuildInputs = with py.pkgs; [
    awesome-slugify flask flask_assets rsa requests pkginfo watchdog
    semantic-version werkzeug flaskbabel tornado
    psutil pyserial flask_login netaddr markdown
    pylru pyyaml sarge feedparser netifaces click websocket_client
    scandir chainmap future wrapt monotonic emoji jinja2
    frozendict cachelib sentry-sdk filetype markupsafe
  ] ++ lib.optionals stdenv.isDarwin [ py.pkgs.appdirs ];

  checkInputs = with py.pkgs; [ nose mock ddt ];

  checkPhase = ''
    HOME=$(mktemp -d) nosetests --exclude-test=util.test_pip.test_check_setup ${lib.optionalString stdenv.isDarwin "--exclude=test_set_external_modification"}
  '';

  meta = with stdenv.lib; {
    homepage = https://octoprint.org/;
    description = "The snappy web interface for your 3D printer";
    license = licenses.agpl3;
    maintainers = with maintainers; [ abbradar gebner WhittlesJr ];
  };
}
