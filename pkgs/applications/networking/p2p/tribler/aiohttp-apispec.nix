{ lib, buildPythonPackage, fetchPypi, pythonOlder
, aiohttp, webargs, fetchFromGitHub, callPackage
}:

let
  apispec3 = callPackage ./apispec.nix {};
  jinja2 = callPackage ../../../../development/python2-modules/jinja2 {};
in
buildPythonPackage rec {
  pname = "aiohttp-apispec";
  version = "unstable-2021-21-08";

  # unstable so we can use latest webargs
  src = fetchFromGitHub {
    owner = "maximdanilchenko";
    repo = "aiohttp-apispec";
    rev = "cfa19646394480dda289f6b7af19b7d50f245d81";
    sha256 = "uEgDRAlMjTa4rvdE3fkORCHIlCLzxPJJ2/m4ZRU3eIQ=";
    fetchSubmodules = false;
  };

  propagatedBuildInputs = [ aiohttp webargs apispec3 jinja2 ];

  pythonImportsCheck = [
    "aiohttp_apispec"
  ];

  # Requires pytest-sanic, currently broken in nixpkgs
  doCheck = false;

  meta = with lib; {
    description = "Build and document REST APIs with aiohttp and apispec";
    homepage = "https://github.com/maximdanilchenko/aiohttp-apispec/";
    license = licenses.mit;
    maintainers = [ maintainers.viric ];
  };
}
