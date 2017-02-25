{ stdenv, fetchFromGitHub, pythonPackages, fetchurl }:

let

  tornado_4_0_2 = pythonPackages.buildPythonPackage rec {
    name = "tornado-${version}";
    version = "4.0.2";

    propagatedBuildInputs = with pythonPackages; [ backports_ssl_match_hostname_3_4_0_2 certifi ];

    src = fetchurl {
      url = "mirror://pypi/t/tornado/${name}.tar.gz";
      sha256 = "1yhvn8i05lp3b1953majg48i8pqsyj45h34aiv59hrfvxcj5234h";
    };
  };

  sockjs-tornado = pythonPackages.buildPythonPackage rec {
    name = "sockjs-tornado-${version}";
    version = "1.0.3";

    src = fetchurl {
      url = "mirror://pypi/s/sockjs-tornado/${name}.tar.gz";
      sha256 = "16cff40nniqsyvda1pb2j3b4zwmrw7y2g1vqq78lp20xpmhnwwkd";
    };

    # This is needed for compatibility with OctoPrint
    propagatedBuildInputs = [ tornado_4_0_2 ];
  };

  websocket_client = pythonPackages.buildPythonPackage rec {
    name = "websocket_client-0.32.0";

    src = fetchurl {
      url = "mirror://pypi/w/websocket-client/${name}.tar.gz";
      sha256 = "cb3ab95617ed2098d24723e3ad04ed06c4fde661400b96daa1859af965bfe040";
    };

    propagatedBuildInputs = with pythonPackages; [ six backports_ssl_match_hostname_3_4_0_2 unittest2 argparse ];
  };

  flask_login = pythonPackages.buildPythonPackage rec {
    name = "Flask-Login-${version}";
    version = "0.2.2";

    src = fetchurl {
      url = "mirror://pypi/F/Flask-Login/${name}.tar.gz";
      sha256 = "09ygn0r3i3jz065a5psng6bhlsqm78msnly4z6x39bs48r5ww17p";
    };

    propagatedBuildInputs = with pythonPackages; [ flask ];

    # FIXME
    doCheck = false;
  };

in pythonPackages.buildPythonApplication rec {
  name = "OctoPrint-${version}";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "foosel";
    repo = "OctoPrint";
    rev = version;
    sha256 = "1av755agyym1k5ig9av0q9ysf26ldfixz82x73v3g47a1m28pxq9";
  };

  # We need old Tornado
  propagatedBuildInputs = with pythonPackages; [
    awesome-slugify flask_assets rsa requests2 pkginfo watchdog
    semantic-version flask_principal werkzeug flaskbabel tornado_4_0_2
    psutil pyserial flask_login netaddr markdown sockjs-tornado
    pylru pyyaml sarge feedparser netifaces click websocket_client
    scandir chainmap future
  ];

  # Jailbreak dependencies.
  # Currently broken for new: tornado, pyserial, flask_login
  postPatch = ''
    sed -i \
      -e 's,werkzeug>=[^"]*,werkzeug,g' \
      -e 's,requests>=[^"]*,requests,g' \
      -e 's,pkginfo>=[^"]*,pkginfo,g' \
      -e 's,semantic_version>=[^"]*,semantic_version,g' \
      -e 's,psutil>=[^"]*,psutil,g' \
      -e 's,Flask-Babel>=[^"]*,Flask-Babel,g' \
      -e 's,Flask-Principal>=[^"]*,Flask-Principal,g' \
      -e 's,markdown>=[^"]*,markdown,g' \
      -e 's,Flask-Assets>=[^"]*,Flask-Assets,g' \
      -e 's,rsa>=[^"]*,rsa,g' \
      -e 's,PyYAML>=[^"]*,PyYAML,g' \
      -e 's,flask>=[^"]*,flask,g' \
      -e 's,Click>=[^"]*,Click,g' \
      -e 's,websocket-client>=[^"]*,websocket-client,g' \
      -e 's,scandir>=[^"]*,scandir,g' \
      -e 's,Jinja2>=[^"]*,Jinja2,g' \
      setup.py
  '';

  meta = with stdenv.lib; {
    homepage = "http://octoprint.org/";
    description = "The snappy web interface for your 3D printer";
    license = licenses.agpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
