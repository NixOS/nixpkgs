{ lib, fetchPypi, nixosTests, python3 }:

python3.pkgs.buildPythonApplication rec {
  version = "0.5.0b3.dev85";
  pname = "pyload-ng";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    # The uploaded tarball uses an underscore in recent releases
    pname = "pyload_ng";
    hash = "sha256-KLpfh53JKqe0kZLcQ1C4fXFFYeO5pPhia9fRxWsbIHY=";
  };

  patches = [
    # Makes it possible to change the default username/password in the module
    ./declarative-default-user.patch
    # Makes it possible to change the configuration through environment variables
    # in the NixOS module (aimed mostly at listen address/port)
    ./declarative-env-config.patch
  ];

  postPatch = ''
    # relax version bounds
    sed -i 's/\([A-z0-9]*\)~=.*$/\1/' setup.cfg
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

  passthru = {
    optional-dependencies = {
      plugins = with python3.pkgs; [
        beautifulsoup4 # for some plugins
        colorlog # colorful console logging
        pillow # for some CAPTCHA plugin
        send2trash # send some files to trash instead of deleting them
        slixmpp # XMPP plugin
      ];
    };

    tests = {
      inherit (nixosTests) pyload;
    };
  };

  meta = with lib; {
    description = "Free and open-source download manager with support for 1-click-hosting sites";
    homepage = "https://github.com/pyload/pyload";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ruby0b ];
    mainProgram = "pyload";
  };
}
