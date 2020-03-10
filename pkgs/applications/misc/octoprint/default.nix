{ stdenv, lib, fetchFromGitHub, python2 }:

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

      (pself: psuper: {
        sentry-sdk = psuper.sentry-sdk.overridePythonAttrs (oldAttrs: rec {
          version = "0.13.2";
          src = oldAttrs.src.override {
            inherit version;
            sha256 = "ff1fa7fb85703ae9414c8b427ee73f8363232767c9cd19158f08f6e4f0b58fc7";
          };
          checkInputs = with pself; [flask bottle falcon];
        });
      })

      # Octoprint holds back jinja2 to 2.8.1 due to breaking changes.
      # This old version does not have updated test config for pytest 4,
      # and pypi tarball doesn't contain tests dir anyways.
      (pself: psuper: {
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

  ignoreVersionConstraints = [
    "Click"
    "Flask-Assets"
    "Flask-Babel"
    "Flask-Principal"
    "emoji"
    "flask"
    "future"
    "futures"
    "monotonic"
    "markdown"
    "pkginfo"
    "psutil"
    "pyserial"
    "requests"
    "rsa"
    "sarge"
    "scandir"
    "semantic_version"
    "watchdog"
    "websocket-client"
    "wrapt"
    "sentry-sdk"
    "werkzeug" # 0.16 just deprecates some stuff
  ];

in py.pkgs.buildPythonApplication rec {
  pname = "OctoPrint";
  version = "1.3.12";

  src = fetchFromGitHub {
    owner  = "foosel";
    repo   = "OctoPrint";
    rev    = version;
    sha256 = "1lmqssgwjyhknjf3x58g7cr0fqz7fs5a3rl07r69wfpch63ranyd";
  };

  propagatedBuildInputs = with py.pkgs; [
    awesome-slugify flask_assets rsa requests pkginfo watchdog
    semantic-version flask_principal werkzeug flaskbabel tornado
    psutil pyserial flask_login netaddr markdown sockjs-tornado
    pylru pyyaml sarge feedparser netifaces click websocket_client
    scandir chainmap future futures wrapt monotonic emoji
    frozendict cachelib sentry-sdk typing filetype
  ] ++ lib.optionals stdenv.isDarwin [ py.pkgs.appdirs ];

  checkInputs = with py.pkgs; [ nose mock ddt ];

  postPatch = ''
    sed -r -i \
      ${lib.concatStringsSep "\n" (map (e:
        ''-e 's@${e}[<>=]+.*@${e}",@g' \''
      ) ignoreVersionConstraints)}
      setup.py
  '';

  checkPhase = ''
    HOME=$(mktemp -d) nosetests ${lib.optionalString stdenv.isDarwin "--exclude=test_set_external_modification"}
  '';

  meta = with stdenv.lib; {
    homepage = https://octoprint.org/;
    description = "The snappy web interface for your 3D printer";
    license = licenses.agpl3;
    maintainers = with maintainers; [ abbradar gebner ];
  };
}
