{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "scons";
  version = "4.8.1";

  src = fetchFromGitHub {
    owner = "Scons";
    repo = "scons";
    tag = version;
    hash = "sha256-3B7DrWfHVJBs19mWAlm4/EGbu6FqppIq3Q1vH2Xsj6U=";
  };

  pyproject = true;

  patches = [ ./env.patch ];

  # Fix builds on sandboxed Darwin: https://github.com/SCons/scons/pull/4603
  postPatch = ''
    substituteInPlace SCons/Platform/darwin.py \
      --replace-fail "except FileNotFoundError" "except (FileNotFoundError, PermissionError)"
  '';

  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.distutils ];

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
    maintainers = with lib.maintainers; [ ];
  };
}
