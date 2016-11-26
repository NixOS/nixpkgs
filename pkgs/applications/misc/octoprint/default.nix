{ stdenv, fetchFromGitHub, pythonPackages, fetchurl }:

let

  tornado_4_0_1 = pythonPackages.buildPythonPackage rec {
    name = "tornado-${version}";
    version = "4.0.1";

    propagatedBuildInputs = with pythonPackages; [ backports_ssl_match_hostname_3_4_0_2 certifi ];

    src = fetchurl {
      url = "mirror://pypi/t/tornado/${name}.tar.gz";
      sha256 = "00crp5vnasxg7qyjv89qgssb69vd7qr13jfghdryrcbnn9l8c1df";
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
    propagatedBuildInputs = [ tornado_4_0_1 ];

    meta = with stdenv.lib; {
      description = "SockJS python server implementation on top of Tornado framework";
      homepage = "http://github.com/mrjoes/sockjs-tornado/";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = with maintainers; [ abbradar ];
    };
  };

in pythonPackages.buildPythonApplication rec {
  name = "OctoPrint-${version}";
  version = "1.2.17";

  src = fetchFromGitHub {
    owner = "foosel";
    repo = "OctoPrint";
    rev = version;
    sha256 = "1di2f5npwsfckx5p2fl23bl5zi75i0aksd9qy4sa3zmw672337fh";
  };

  # We need old Tornado
  propagatedBuildInputs = with pythonPackages; [
    awesome-slugify flask_assets rsa requests2 pkginfo watchdog
    semantic-version flask_principal werkzeug flaskbabel tornado_4_0_1
    psutil pyserial flask_login netaddr markdown sockjs-tornado
    pylru pyyaml sarge feedparser netifaces
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
      -e 's,Flask-Login>=[^"]*,Flask-Login,g' \
      -e 's,rsa>=[^"]*,rsa,g' \
      -e 's,PyYAML>=[^"]*,PyYAML,g' \
      setup.py
  '';

  meta = with stdenv.lib; {
    homepage = "http://octoprint.org/";
    description = "The snappy web interface for your 3D printer";
    license = licenses.agpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
