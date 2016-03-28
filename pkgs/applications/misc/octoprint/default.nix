{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "OctoPrint-${version}";
  version = "1.2.10";

  src = fetchFromGitHub {
    owner = "foosel";
    repo = "OctoPrint";
    rev = version;
    sha256 = "1ips1083c4qrfnkssvp1lxrs92svlid29l225ifsymrinpbjawav";
  };

  # We need old Tornado
  propagatedBuildInputs = with pythonPackages; [
    awesome-slugify flask_assets watchdog rsa requests2 pkginfo pylru
    semantic-version flask_principal sarge tornado_4_0_1 werkzeug netaddr flaskbabel
    netifaces psutil pyserial flask_login pyyaml sockjs-tornado
  ];

  postPatch = ''
    # Jailbreak dependencies
    sed -i \
      -e 's,rsa==,rsa>=,g' \
      -e 's,sockjs-tornado==,sockjs-tornado>=,g' \
      -e 's,Flask-Principal==,Flask-Principal>=,g' \
      -e 's,werkzeug==,werkzeug>=,g' \
      -e 's,netaddr==,netaddr>=,g' \
      -e 's,requests==,requests>=,g' \
      -e 's,netifaces==,netifaces>=,g' \
      -e 's,psutil==,psutil>=,g' \
      -e 's,PyYAML==,PyYAML>=,g' \
      setup.py
  '';

  meta = with stdenv.lib; {
    homepage = http://octoprint.org/;
    description = "The snappy web interface for your 3D printer";
    platforms = platforms.all;
    license = licenses.agpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
