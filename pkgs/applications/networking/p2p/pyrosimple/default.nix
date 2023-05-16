{ lib
, stdenv
<<<<<<< HEAD
, fetchFromGitHub
, nix-update-script
, pyrosimple
, python3
, testers
, withInotify ? stdenv.isLinux
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pyrosimple";
  version = "2.10.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "kannibalox";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-3ZsRJNGbcKGU6v2uYUintMpKY8Z/DyTIDDxTsDEV6lw=";
  };

  pythonRelaxDeps = [
    "prometheus-client"
    "python-daemon"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
=======
, python3Packages
, nix-update-script
, pyrosimple
, testers
, fetchPypi
, buildPythonPackage
, bencode-py
, apscheduler
, jinja2
, python-daemon
, importlib-resources
, parsimonious
, prometheus-client
, prompt-toolkit
, requests
, shtab
, inotify
, withInotify ? stdenv.isLinux
, python-box
, tomli
, tomli-w
}:

let
  pname = "pyrosimple";
  version = "2.7.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SMqzvTbWFHwnbMQ+6K0m1v+PybceQK5EHEuN8FB6SaU=";
  };

  propagatedBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    bencode-py
    apscheduler
    jinja2
    python-daemon
    importlib-resources
    parsimonious
    prometheus-client
    prompt-toolkit
    requests
    shtab
    python-box
<<<<<<< HEAD
    tomli-w
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ] ++ lib.optional withInotify inotify;

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];
=======
    tomli
    tomli-w
  ] ++ lib.optional withInotify inotify;

in buildPythonPackage {
  inherit pname version src propagatedBuildInputs;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru = {
    updateScript = nix-update-script { };
    tests = testers.testVersion {
      package = pyrosimple;
      command = "pyroadmin --version";
    };
  };

<<<<<<< HEAD
  meta = with lib; {
    description = "A rTorrent client";
    homepage = "https://kannibalox.github.io/pyrosimple/";
    changelog = "https://github.com/kannibalox/pyrosimple/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ne9z vamega ];
  };
=======
  meta = let inherit (lib) licenses platforms maintainers;
  in {
    homepage = "https://kannibalox.github.io/pyrosimple/";
    description = "A rTorrent client and Python 3 fork of the pyrocore tools";
    license = licenses.gpl3Plus;
    changelog = "https://github.com/kannibalox/pyrosimple/blob/v${version}/CHANGELOG.md";
    platforms = platforms.all;
    maintainers = builtins.attrValues { inherit (maintainers) ne9z; };
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
