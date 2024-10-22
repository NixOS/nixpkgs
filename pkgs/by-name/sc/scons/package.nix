{ lib, fetchFromGitHub, python3Packages }:
python3Packages.buildPythonApplication rec {
  pname = "scons";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "Scons";
    repo = "scons";
    rev = version;
    hash = "sha256-7VzGuz9CAUF6MRCEpj5z1FkZD19/Ic+YBukYQocvkr0=";
  };

  pyproject = true;

  patches = [
    ./env.patch
    ./no-man-pages.patch
  ];

  build-system = [
    python3Packages.setuptools
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
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
