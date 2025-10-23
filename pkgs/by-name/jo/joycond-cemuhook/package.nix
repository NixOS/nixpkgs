{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "joycond-cemuhook";
  version = "0-unstable-2023-08-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joaorb64";
    repo = "joycond-cemuhook";
    rev = "3c0e07374ff431a0f8ae70dbb0b5a62fb3de06ee";
    hash = "sha256-K24CEmYWhgkvVX4geg2bylH8TSvHIpsWjsPwY5BpquI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'setuptools-git-versioning<2' 'setuptools-git-versioning'
  '';

  build-system = with python3Packages; [
    setuptools
    setuptools-git-versioning
  ];

  dependencies = with python3Packages; [
    dbus-python
    evdev
    pyudev
    termcolor
  ];

  meta = with lib; {
    homepage = "https://github.com/joaorb64/joycond-cemuhook";
    description = "Support for cemuhook's UDP protocol for joycond devices";
    license = licenses.mit;
    maintainers = [ maintainers.noodlez1232 ];
    mainProgram = "joycond-cemuhook";
    platforms = platforms.linux;
  };
}
