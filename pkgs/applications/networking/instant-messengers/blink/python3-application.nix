{ lib, isPy3k, buildPythonPackage, fetchFromGitHub, zope_interface, twisted, ... }:

buildPythonPackage rec {
  pname = "python3-application";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python3-application";
    rev = "8209f3334c9b603fc81509333c38909755f663db";
    sha256 = "sha256-hZeG5y/fDTy7EuSkFG8ruMGwK5UaqUv8I3bj4Egyl6A=";
  };

  propagatedBuildInputs = [ zope_interface twisted ];

  disabled = !isPy3k;

  pythonImportsCheck = [ "application" ];

  meta = with lib; {
    description = "A collection of modules that are useful when building python applications";
    homepage = "https://github.com/AGProjects/python3-application";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ chanley ];
    longDescription = ''
      This package is a collection of modules that are useful when building python applications. Their purpose is to eliminate the need to divert resources into implementing the small tasks that every application needs to do in order to run successfully and focus instead on the application logic itself.
      The modules that the application package provides are:
        1. process - UNIX process and signal management.
        2. python - python utility classes and functions.
        3. configuration - a simple interface to handle configuration files.
        4. log - an extensible system logger for console and syslog.
        5. debug - memory troubleshooting and execution timing.
        6. system - interaction with the underlying operating system.
        7. notification - an application wide notification system.
        8. version - manage version numbers for applications and packages.
    '';
  };
}
