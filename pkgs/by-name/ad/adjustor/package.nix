{
  fetchFromGitHub,
  lib,
  python3Packages,

  # Dependencies
  kmod,
  util-linux,
}:
python3Packages.buildPythonPackage rec {
  pname = "adjustor";
  version = "3.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hhd-dev";
    repo = "adjustor";
    rev = "refs/tags/v${version}";
    hash = "sha256-A5IdwuhsK9umMtsUR7CpREGxbTYuJNPV4MT+6wqcWT8=";
  };

  # This package relies on several programs expected to be on the user's PATH.
  # We take a more reproducible approach by patching the absolute path to each of these required
  # binaries.
  postPatch = ''
    substituteInPlace src/adjustor/core/acpi.py \
      --replace-fail '"modprobe"' '"${lib.getExe' kmod "modprobe"}"'

    substituteInPlace src/adjustor/fuse/utils.py \
      --replace-fail 'f"mount' 'f"${lib.getExe' util-linux "mount"}'
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    rich
    pyroute2
    fuse
    pygobject3
    dbus-python
    kmod
  ];

  # This package doesn't have upstream tests.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/hhd-dev/adjustor/";
    description = "Adjustor TDP plugin for Handheld Daemon";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ toast ];
    mainProgram = "hhd";
  };
}
