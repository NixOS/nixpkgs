{
  lib,
  python3Packages,
  fetchPypi,
}:

let
  # https://github.com/NixOS/nixpkgs/issues/348788
  pythonPackages = python3Packages.overrideScope (
    self: super: {
      mistune = super.mistune.overridePythonAttrs (oldAttrs: rec {
        version = "2.0.5";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-AkYRPLJJLbh1xr5Wl0p8iTMzvybNkokchfYxUc7gnTQ=";
        };
      });
    }
  );
in
pythonPackages.buildPythonPackage rec {
  pname = "present";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l9W5L4LD9qRo3rLBkgd2I/aDaj+ucib5UYg+X4RYg6c=";
  };

  build-system = with pythonPackages; [ setuptools ];

  dependencies = with pythonPackages; [
    click
    pyyaml
    pyfiglet
    asciimatics
    mistune
  ];

  pythonImportsCheck = [ "present" ];

  # TypeError: don't know how to make test from: 0.6.0
  doCheck = false;

  meta = {
    description = "Terminal-based presentation tool with colors and effects";
    homepage = "https://github.com/vinayak-mehta/present";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "present";
  };
}
