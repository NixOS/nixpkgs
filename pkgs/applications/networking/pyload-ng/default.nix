{ lib, fetchPypi, python3 }:

python3.pkgs.buildPythonApplication rec {
  version = "0.5.0b3.dev75";
  pname = "pyload-ng";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1lPIKkZESonDaVCnac0iUu/gCqXVDBhNZrk5S0eC6F0=";
  };

  postPatch = ''
    # relax version bounds
    sed -i 's/\([A-z0-9]*\)~=.*$/\1/' setup.cfg
    # not sure what Flask-Session2 is but flask-session works just fine
    sed -i '/Flask-Session2/d' setup.cfg
  '';

  propagatedBuildInputs = with python3.pkgs; [
    bitmath
    certifi
    cheroot
    cryptography
    filetype
    flask
    flask-babel
    flask-caching
    flask-compress
    flask-session
    flask-themes2
    js2py
    pycurl
    semver
    setuptools
  ];

  passthru.optional-dependencies = {
    plugins = with python3.pkgs; [
      beautifulsoup4 # for some plugins
      colorlog # colorful console logging
      pillow # for some CAPTCHA plugin
      send2trash # send some files to trash instead of deleting them
      slixmpp # XMPP plugin
    ];
  };

  meta = with lib; {
    description = "Free and open-source download manager with support for 1-click-hosting sites";
    homepage = "https://github.com/pyload/pyload";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ruby0b ];
    mainProgram = "pyload";
  };
}
