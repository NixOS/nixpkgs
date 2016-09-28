{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "OctoPrint-${version}";
  version = "1.2.15";

  src = fetchFromGitHub {
    owner = "foosel";
    repo = "OctoPrint";
    rev = version;
    sha256 = "0qfragp7n8m7l5l30s5fz1x7xzini2sdh2y3m1ahs7ay8zp4xk56";
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
