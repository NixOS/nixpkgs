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
      (mkOverride "jinja2"      "2.8.1"  "14aqmhkc9rw5w0v311jhixdm6ym8vsm29dhyxyrjfqxljwx1yd1m")
      (mkOverride "pylru"       "1.0.9"  "0b0pq0l7xv83dfsajsc49jcxzc99kb9jfx1a1dlx22hzcy962dvi")
      (mkOverride "sarge"       "0.1.4"  "08s8896973bz1gg0pkr592w6g4p6v47bkfvws5i91p9xf8b35yar")
      (mkOverride "tornado"     "4.5.3"  "02jzd23l4r6fswmwxaica9ldlyc2p6q8dk6dyff7j58fmdzf853d")
    ]);
  };

  ignoreVersionConstraints = [
    "Click"
    "Flask-Assets"
    "Flask-Babel"
    "Flask-Principal"
    "PyYAML"
    "emoji"
    "flask"
    "future"
    "futures"
    "pkginfo"
    "psutil"
    "pyserial"
    "python-dateutil"
    "requests"
    "rsa"
    "scandir"
    "semantic_version"
    "websocket-client"
    "werkzeug"
    "wrapt"
  ];

in py.pkgs.buildPythonApplication rec {
  pname = "OctoPrint";
  version = "1.3.9";

  src = fetchFromGitHub {
    owner  = "foosel";
    repo   = "OctoPrint";
    rev    = version;
    sha256 = "1yqbsfmkx4wiykjrh66a05lhn15qhpc9ay67l37kv8bhdqf2xkj4";
  };

  propagatedBuildInputs = with py.pkgs; [
    awesome-slugify flask_assets rsa requests pkginfo watchdog
    semantic-version flask_principal werkzeug flaskbabel tornado
    psutil pyserial flask_login netaddr markdown sockjs-tornado
    pylru pyyaml sarge feedparser netifaces click websocket_client
    scandir chainmap future dateutil futures wrapt monotonic emoji
    frozendict
  ];

  checkInputs = with py.pkgs; [ nose mock ddt ];

  postPatch = ''
    sed -r -i \
      ${lib.concatStringsSep "\n" (map (e:
        ''-e 's@${e}[<>=]+.*@${e}",@g' \''
      ) ignoreVersionConstraints)}
      setup.py
  '';

  checkPhase = "nosetests";

  meta = with stdenv.lib; {
    homepage = https://octoprint.org/;
    description = "The snappy web interface for your 3D printer";
    license = licenses.agpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
