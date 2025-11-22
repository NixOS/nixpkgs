{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "scons";
  version = "4.10.0";

  src = fetchFromGitHub {
    owner = "Scons";
    repo = "scons";
    tag = version;
    hash = "sha256-ZmJETrznHH3zsNBO5o8JCvf+6l7NICOAfIqASYzYBaM=";
  };

  pyproject = true;

  patches = [ ./env.patch ];

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = [
    python3Packages.distutils
  ];

  setupHook = ./setup-hook.sh;

  passthru = {
    # expose the used python version so tools using this (and extensing scos
    # with other python modules) can use the exact same python version.
    inherit (python3Packages) python;
  };

  meta = {
    description = "Improved, cross-platform substitute for Make";
    longDescription = ''
      SCons is an Open Source software construction tool. Think of SCons as an
      improved, cross-platform substitute for the classic Make utility with
      integrated functionality similar to autoconf/automake and compiler caches
      such as ccache. In short, SCons is an easier, more reliable and faster way
      to build software.
    '';
    homepage = "https://scons.org/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
