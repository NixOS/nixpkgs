{ stdenv, fetchgit, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "lastwatch-${version}";
  namePrefix = "";
  version = "0.4.1";

  src = fetchgit {
    url = "git://github.com/aszlig/LastWatch.git";
    rev = "refs/tags/v${version}";
    sha256 = "c43f0fd87e9f3daafc7e8676daf2e89c8e21fbabc278eb1455e28d2997587a92";
  };

  pythonPath = [
    pythonPackages.pyinotify
    pythonPackages.pylast
    pythonPackages.mutagen
  ];

  propagatedBuildInputs = pythonPath;

  installCommand = "python setup.py install --prefix=$out";

  meta = {
    homepage = "https://github.com/aszlig/LastWatch";
    description = "An inotify-based last.fm audio scrobbler";
    license = stdenv.lib.licenses.gpl2;
  };
}
