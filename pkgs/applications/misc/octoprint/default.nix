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

  py = python2.override {
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) ([
      (mkOverride "flask"       "0.10.1" "0wrkavjdjndknhp8ya8j850jq7a1cli4g5a93mg8nh1xz2gq50sc")
      (mkOverride "flask_login" "0.2.11" "1rg3rsjs1gwi2pw6vr9jmhaqm9b3vc9c4hfcsvp4y8agbh7g3mc3")
      (mkOverride "tornado"     "4.5.3"  "02jzd23l4r6fswmwxaica9ldlyc2p6q8dk6dyff7j58fmdzf853d")

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
  ];

in py.pkgs.buildPythonApplication rec {
  pname = "OctoPrint";
  version = "1.3.11";

  src = fetchFromGitHub {
    owner  = "foosel";
    repo   = "OctoPrint";
    rev    = version;
    sha256 = "1102ki1819wsmkfg4riz4i0hjlr3w6nsvk8wrzqq0lc0s5ycf4jx";
  };

  propagatedBuildInputs = with py.pkgs; [
    awesome-slugify flask_assets rsa requests pkginfo watchdog
    semantic-version flask_principal werkzeug flaskbabel tornado
    psutil pyserial flask_login netaddr markdown sockjs-tornado
    pylru pyyaml sarge feedparser netifaces click websocket_client
    scandir chainmap future futures wrapt monotonic emoji
    frozendict cachelib sentry-sdk typing
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
    maintainers = with maintainers; [ abbradar ];
  };
}
