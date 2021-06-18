{ lib
, fetchFromGitHub
, python3Packages, python27Packages
, wmctrl, qtbase, mkDerivationWith
}:

rec {
  stable = with python27Packages; buildPythonPackage rec {
    pname = "plover";
    version = "3.1.1";

    meta = with lib; {
      description = "OpenSteno Plover stenography software";
      maintainers = with maintainers; [ twey kovirobi ];
      license     = licenses.gpl2;
    };

    src = fetchFromGitHub {
      owner = "openstenoproject";
      repo = "plover";
      rev = "v${version}";
      sha256 = "114rlxvq471fyifwcdcgdad79ak7q3w2lk8z9nqhz1i9fg05721c";
    };

    nativeBuildInputs     = [ setuptools-scm ];
    buildInputs           = [ pytest mock ];
    propagatedBuildInputs = [
      six setuptools pyserial appdirs hidapi wxPython xlib wmctrl dbus-python
    ];
  };

  dev = with python3Packages; mkDerivationWith buildPythonPackage rec {
    pname = "plover";
    version = "4.0.0.dev9";

    meta = with lib; {
      description = "OpenSteno Plover stenography software";
      maintainers = with maintainers; [ twey kovirobi ];
      license     = licenses.gpl2Plus;
    };

    src = fetchFromGitHub {
      owner = "openstenoproject";
      repo = "plover";
      rev = "54dbcf4ea73cc1ecc1d7c70dbe7bdb13f055d101";
      sha256 = "1jm6rajlh8nm1b1331pyvp20vxxfwi4nb8wgqlkznf0kkdvfa78a";
    };

    checkInputs           = [ pytest mock ];
    propagatedBuildInputs = [
      Babel pyqt5 xlib pyserial
      appdirs wcwidth setuptools
      certifi
    ];

    dontWrapQtApps = true;

    preFixup = ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    '';
  };

  plugins-manager = with python3Packages; buildPythonPackage rec {
    pname = "plover-plugins-manager";
    version = "0.6.1";

    src = fetchFromGitHub {
      owner = "benoit-pierre";
      repo = "plover_plugins_manager";
      rev = version;
      sha256 = "sha256-7OyGmSwOvoqwbBgXdfUUmwvjszUNRPlD4XyBeJ29vBg=";
    };

    patches = [ ./plugins_manager.patch ];

    buildInputs = [
      # plover.dev
      dev
    ];

    propagatedBuildInputs = [
      pip pkginfo pygments
      readme_renderer requests
      requests-cache requests-futures
      setuptools wheel
    ];

    # tests try to instantiate a virtualenv and lack permission
    doCheck = false;

    meta = with lib; {
      description = "OpenSteno Plover stenography software plugin manager";
      homepage = "https://github.com/benoit-pierre/plover_plugins_manager";
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ evils ];
    };
  };

  dev-with-plugins = dev.overrideAttrs (old: {
    pname = "plover-with-plugins";
    propagatedBuildInputs = old.propagatedBuildInputs ++ [ plugins-manager ];

    # the plugin manager installs plugins as local python packages
    permitUserSite = true;
  });
}
