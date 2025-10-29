{
  lib,
  fetchFromGitHub,
  python3Packages,
  glibcLocales,
}:

python3Packages.buildPythonApplication rec {
  pname = "i3minator";
  version = "0.0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "carlesso";
    repo = "i3minator";
    rev = version;
    sha256 = "07dic5d2m0zw0psginpl43xn0mpxw7wilj49d02knz69f7c416lm";
  };

  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = [
    python3Packages.pyyaml
    python3Packages.i3-py
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "i3minator" ];

  meta = {
    description = "i3 project manager similar to tmuxinator";
    mainProgram = "i3minator";
    longDescription = ''
      A simple "workspace manager" for i3. It allows to quickly
      manage workspaces defining windows and their layout. The
      project is inspired by tmuxinator and uses i3-py.
    '';
    homepage = "https://github.com/carlesso/i3minator";
    license = lib.licenses.wtfpl;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };

}
