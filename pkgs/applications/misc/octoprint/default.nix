{ stdenv, fetchFromGitHub, python2, fetchurl }:

let

  pythonPackages = python2.pkgs.override {
    overrides = self: super: with self; {
      backports_ssl_match_hostname = self.backports_ssl_match_hostname_3_4_0_2;

      tornado = buildPythonPackage rec {
        name = "tornado-${version}";
        version = "4.0.2";

        propagatedBuildInputs = [ backports_ssl_match_hostname certifi ];

        src = fetchurl {
          url = "mirror://pypi/t/tornado/${name}.tar.gz";
          sha256 = "1yhvn8i05lp3b1953majg48i8pqsyj45h34aiv59hrfvxcj5234h";
        };
      };

      flask_login = buildPythonPackage rec {
        name = "Flask-Login-${version}";
        version = "0.2.2";

        src = fetchurl {
          url = "mirror://pypi/F/Flask-Login/${name}.tar.gz";
          sha256 = "09ygn0r3i3jz065a5psng6bhlsqm78msnly4z6x39bs48r5ww17p";
        };

        propagatedBuildInputs = [ flask ];
        buildInputs = [ nose ];

        # No tests included
        doCheck = false;
      };

      jinja2 = buildPythonPackage rec {
        pname = "Jinja2";
        version = "2.8.1";
        name = "${pname}-${version}";

        src = fetchurl {
          url = "mirror://pypi/J/Jinja2/${name}.tar.gz";
          sha256 = "14aqmhkc9rw5w0v311jhixdm6ym8vsm29dhyxyrjfqxljwx1yd1m";
        };

        propagatedBuildInputs = [ markupsafe ];

        # No tests included
        doCheck = false;
      };
    };
  };

in pythonPackages.buildPythonApplication rec {
  name = "OctoPrint-${version}";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "foosel";
    repo = "OctoPrint";
    rev = version;
    sha256 = "06l8khbq3waaaa4cqpv6056w1ziylkfgzlb28v30i1h234rlkknq";
  };

  # We need old Tornado
  propagatedBuildInputs = with pythonPackages; [
    awesome-slugify flask_assets rsa requests pkginfo watchdog
    semantic-version flask_principal werkzeug flaskbabel tornado
    psutil pyserial flask_login netaddr markdown sockjs-tornado
    pylru pyyaml sarge feedparser netifaces click websocket_client
    scandir chainmap future dateutil
  ];

  buildInputs = with pythonPackages; [ nose mock ddt ];

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
      -e 's,psutil>=[^"]*,psutil,g' \
      -e 's,requests>=[^"]*,requests,g' \
      -e 's,future>=[^"]*,future,g' \
      setup.py
  '';

  checkPhase = "nosetests";

  meta = with stdenv.lib; {
    homepage = "http://octoprint.org/";
    description = "The snappy web interface for your 3D printer";
    license = licenses.agpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
