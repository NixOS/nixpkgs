{ stdenv, fetchFromGitHub, python2 }:

let

  pythonPackages = python2.pkgs.override {
    overrides = self: super: with self; {
      backports_ssl_match_hostname = super.backports_ssl_match_hostname.overridePythonAttrs (oldAttrs: rec {
        version = "3.4.0.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae";
        };
      });

      flask = super.flask.overridePythonAttrs (oldAttrs: rec {
        version = "0.12.4";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "2ea22336f6d388b4b242bc3abf8a01244a8aa3e236e7407469ef78c16ba355dd";
        };
      });

      tornado = buildPythonPackage rec {
        pname = "tornado";
        version = "4.0.2";

        propagatedBuildInputs = [ backports_ssl_match_hostname certifi ];

        src = fetchPypi {
          inherit pname version;
          sha256 = "1yhvn8i05lp3b1953majg48i8pqsyj45h34aiv59hrfvxcj5234h";
        };
      };

      flask_login = buildPythonPackage rec {
        pname = "Flask-Login";
        version = "0.2.2";

        src = fetchPypi {
          inherit pname version;
          sha256 = "09ygn0r3i3jz065a5psng6bhlsqm78msnly4z6x39bs48r5ww17p";
        };

        propagatedBuildInputs = [ flask ];
        checkInputs = [ nose ];

        # No tests included
        doCheck = false;
      };

      jinja2 = buildPythonPackage rec {
        pname = "Jinja2";
        version = "2.8.1";

        src = fetchPypi {
          inherit pname version;
          sha256 = "14aqmhkc9rw5w0v311jhixdm6ym8vsm29dhyxyrjfqxljwx1yd1m";
        };

        propagatedBuildInputs = [ markupsafe ];

        # No tests included
        doCheck = false;
      };

      pylru = super.pylru.overridePythonAttrs (oldAttrs: rec {
        version = "1.0.9";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "71376192671f0ad1690b2a7427d39a29b1df994c8469a9b46b03ed7e28c0172c";
        };
      });
    };
  };

in pythonPackages.buildPythonApplication rec {
  pname = "OctoPrint";
  version = "1.3.8";

  src = fetchFromGitHub {
    owner = "foosel";
    repo = "OctoPrint";
    rev = version;
    sha256 = "00zd5yrlihwfd3ly0mxibr77ffa8r8vkm6jhml2ml43dqb99caa3";
  };

  # We need old Tornado
  propagatedBuildInputs = with pythonPackages; [
    awesome-slugify flask_assets rsa requests pkginfo watchdog
    semantic-version flask_principal werkzeug flaskbabel tornado
    psutil pyserial flask_login netaddr markdown sockjs-tornado
    pylru pyyaml sarge feedparser netifaces click websocket_client
    scandir chainmap future dateutil futures wrapt monotonic emoji
    frozendict
  ];

  checkInputs = with pythonPackages; [ nose mock ddt ];

  # Jailbreak dependencies.
  postPatch = ''
    sed -i \
      -e 's,pkginfo>=[^"]*,pkginfo,g' \
      -e 's,Flask-Principal>=[^"]*,Flask-Principal,g' \
      -e 's,websocket-client>=[^"]*,websocket-client,g' \
      -e 's,Click>=[^"]*,Click,g' \
      -e 's,rsa>=[^"]*,rsa,g' \
      -e 's,flask>=[^"]*,flask,g' \
      -e 's,Flask-Babel>=[^"]*,Flask-Babel,g' \
      -e 's,Flask-Assets>=[^"]*,Flask-Assets,g' \
      -e 's,PyYAML>=[^"]*,PyYAML,g' \
      -e 's,scandir>=[^"]*,scandir,g' \
      -e 's,werkzeug>=[^"]*,werkzeug,g' \
      -e 's,psutil==[^"]*,psutil,g' \
      -e 's,requests>=[^"]*,requests,g' \
      -e 's,future>=[^"]*,future,g' \
      -e 's,pyserial>=[^"]*,pyserial,g' \
      -e 's,semantic_version>=[^"]*,semantic_version,g' \
      -e 's,wrapt>=[^"]*,wrapt,g' \
      -e 's,python-dateutil>=[^"]*,python-dateutil,g' \
      -e 's,emoji>=[^"]*,emoji,g' \
      -e 's,futures>=[^"]*,futures,g' \
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
