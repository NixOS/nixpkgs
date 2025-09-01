{
  lib,
  fetchPypi,
  fetchpatch,
  python3Packages,
}:
let
  pythonPackages = python3Packages.overrideScope (
    _: prev: {
      pychromecast = prev.pychromecast.overridePythonAttrs (
        let
          version = "13.1.0";
        in
        {
          inherit version;

          src = fetchPypi {
            pname = "PyChromecast";
            inherit version;
            hash = "sha256-COYai1S9IRnTyasewBNtPYVjqpfgo7V4QViLm+YMJnY=";
          };

          postPatch = "";
        }
      );
    }
  );
in
pythonPackages.buildPythonApplication rec {
  pname = "catt";
  version = "0.12.11";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0bqYYfWwF7yYoAbjZPhi/f4CLcL89imWGYaMi5Bwhtc=";
  };

  patches = [
    (fetchpatch {
      # set explicit build-system
      url = "https://github.com/skorokithakis/catt/commit/08e7870a239e85badd30982556adc2aa8a8e4fc1.patch";
      hash = "sha256-QH5uN3zQNVPP6Th2LHdDBF53WxwMhoyhhQUAZOeHh4k=";
    })
  ];

  build-system = [
    pythonPackages.poetry-core
  ];

  dependencies = [
    pythonPackages.click
    pythonPackages.ifaddr
    pythonPackages.pychromecast
    pythonPackages.protobuf
    pythonPackages.requests
    pythonPackages.yt-dlp
  ];

  doCheck = false; # attempts to access various URLs

  pythonImportsCheck = [
    "catt"
  ];

  meta = {
    description = "Send media from online sources to Chromecast devices";
    homepage = "https://github.com/skorokithakis/catt";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.RossSmyth ];
    mainProgram = "catt";
  };
}
