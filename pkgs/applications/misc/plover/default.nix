{ lib, stdenv, fetchurl, fetchFromGitHub, python27Packages, python36Packages, wmctrl, qtbase, mkDerivationWith }:

let
  requests-futures = with python36Packages; buildPythonPackage rec {
    pname = "requests-futures";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "ross";
      repo = "requests-futures";
      rev = "d5cbf487c010dd84c4e030e279d48e7179e35335";
      sha256 = "1f7r3wjs7kg3dzg7zszxxpaax45ps9phclyvvzxi5y86d3shgwdm";
    };

    # tests try to access network
    doCheck = false;

    propagatedBuildInputs = [ requests ];
  };
in rec {

  stable = with python27Packages; buildPythonPackage rec {
    pname = "plover";
    version = "3.1.1";

    meta = with lib; {
      description = "OpenSteno Plover stenography software";
      maintainers = with maintainers; [ twey kovirobi ];
      license     = licenses.gpl2;
    };

    src = fetchurl {
      url    = "https://github.com/openstenoproject/plover/archive/v${version}.tar.gz";
      sha256 = "1hdg5491phx6svrxxsxp8v6n4b25y7y4wxw7x3bxlbyhaskgj53r";
    };

    nativeBuildInputs     = [ setuptools_scm ];
    buildInputs           = [ pytest mock ];
    propagatedBuildInputs = [
      six setuptools pyserial appdirs hidapi wxPython xlib wmctrl dbus-python
    ];
  };

  dev = with python36Packages; mkDerivationWith buildPythonPackage rec {
    pname = "plover";
    version = "4.0.0.dev8";

    meta = with lib; {
      description = "OpenSteno Plover stenography software";
      maintainers = with maintainers; [ twey kovirobi ];
      license     = licenses.gpl2;
    };

    src = fetchurl {
      url    = "https://github.com/openstenoproject/plover/archive/v${version}.tar.gz";
      sha256 = "1wxkmik1zyw5gqig5r0cas5v6f5408fbnximzw610rdisqy09rxp";
    };

    # I'm not sure why we don't find PyQt5 here but there's a similar
    # sed on many of the platforms Plover builds for
    postPatch = "sed -i /PyQt5/d setup.cfg";

    checkInputs           = [ pytest mock ];
    propagatedBuildInputs = [ Babel pyqt5 xlib pyserial appdirs wcwidth setuptools ];

    dontWrapQtApps = true;

    preFixup = ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    '';
  };

  plugins-manager = with python36Packages; buildPythonPackage rec {
    pname = "plover-plugins-manager";
    version = "0.5.16";

    meta = with lib; {
      description = "OpenSteno Plover stenography software plugin manager";
      maintainers = with maintainers; [ tckmn ];
      license     = licenses.gpl2;
    };

    src = fetchFromGitHub {
      owner = "benoit-pierre";
      repo = "plover_plugins_manager";
      rev = "7f697da4a97cf92eeb639742a115a89887155c90";
      sha256 = "152c02anzzvk2a5mgsnlmc1bc48lhgqf58rw2z6ir1x5carpzm91";
    };

    # apply nix sys.path wrapper to plugin manager's python call
    postPatch = "patch -p1 <${./plugins-manager.patch}";

    # tests try to instantiate a virtualenv and lack permission
    doCheck = false;

    propagatedBuildInputs = [ pip pkginfo dev pygments readme_renderer requests requests-cache requests-futures setuptools wheel ];
  };

  dev-with-plugins = dev.overrideAttrs (old: {
    name = "plover-with-plugins-${old.version}";
    propagatedBuildInputs = old.propagatedBuildInputs ++ [ plugins-manager ];

    # we have to remove the old plover from PYTHONPATH; otherwise python thinks
    # it's already installed and refuses to install it again
    preInstall = ''
      export PYTHONPATH="$(sed 's![^:]*-${old.name}-[^:]*:!!g' <<<"$PYTHONPATH")"
    '';

    # the plugin manager installs plugins as local python packages
    permitUserSite = true;
  });

}
