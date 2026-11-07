{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  setuptools,
  rsync,
  toml,
}:

buildPythonPackage rec {
  pname = "sysrsync";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gchamon";
    repo = "sysrsync";
    tag = version;
    hash = "sha256-2Sz3JrNmIGOnad+qjRzbAgsFEzDtwBT0KLEFyQKZra4=";
  };

  postPatch = ''
    substituteInPlace sysrsync/command_maker.py \
      --replace-fail "'rsync'" "'${rsync}/bin/rsync'"
  '';

  build-system = [
    poetry-core
    setuptools
  ];

  dependencies = [
    toml
  ];

  pythonImportsCheck = [ "sysrsync" ];

  meta = {
    description = "Simple and safe system's rsync wrapper for Python";
    homepage = "https://github.com/gchamon/sysrsync";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
