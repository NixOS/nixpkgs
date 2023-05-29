{ lib
, stdenv
, python3Packages
, nix-update-script
, pyrosimple
, testers
, fetchPypi
, buildPythonPackage
, poetry-core
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
  version = "2.8.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K0QjEcGzROlSWuUHWqUbcOdKccrHex2SlwPAmsmIbaQ=";
  };

  nativeBuildInputs = [ poetry-core ];
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
  inherit pname version src nativeBuildInputs propagatedBuildInputs;

  format = "pyproject";

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
