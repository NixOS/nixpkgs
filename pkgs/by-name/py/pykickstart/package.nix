{
  lib,
  python3Packages,
  fetchFromGitHub,
  gettext,
  gitMinimal,
}:

python3Packages.buildPythonApplication rec {
  pname = "pykickstart";
  version = "3.64";

  src = fetchFromGitHub {
    owner = "pykickstart";
    repo = "pykickstart";
    tag = "r${version}";
    hash = "sha256-EDbS06d/lFOSxI/qP7Uovr1qgJqlRyH7gfHnAevHo6o=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    requests
  ];

  nativeBuildInputs = [
    gettext
    gitMinimal
  ];

  # All checks are for RedHat's weird translation library.
  # Can't package it and not really necessary so disable them.
  doCheck = false;

  meta = {
    description = "Python package to interact with Kickstart files commonly found in the RPM world";
    homepage = "https://github.com/pykickstart/pykickstart";
    changelog = "https://github.com/pykickstart/pykickstart/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      thefossguy
    ];
  };
}
