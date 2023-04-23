{ lib
, stdenv
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
    tomli
    tomli-w
  ] ++ lib.optional withInotify inotify;

in buildPythonPackage {
  inherit pname version src propagatedBuildInputs;

  passthru = {
    updateScript = nix-update-script { };
    tests = testers.testVersion {
      package = pyrosimple;
      command = "pyroadmin --version";
    };
  };

  meta = let inherit (lib) licenses platforms maintainers;
  in {
    homepage = "https://kannibalox.github.io/pyrosimple/";
    description = "A rTorrent client and Python 3 fork of the pyrocore tools";
    license = licenses.gpl3Plus;
    changelog = "https://github.com/kannibalox/pyrosimple/blob/v${version}/CHANGELOG.md";
    platforms = platforms.all;
    maintainers = builtins.attrValues { inherit (maintainers) ne9z; };
  };

}
