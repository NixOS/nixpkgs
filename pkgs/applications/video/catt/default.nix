{ lib
, fetchPypi
, fetchpatch
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "catt";
  version = "0.12.11";
  format = "pyproject";

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

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    ifaddr
    pychromecast
    protobuf
    requests
    yt-dlp
  ];

  doCheck = false; # attempts to access various URLs

  pythonImportsCheck = [
    "catt"
  ];

  meta = with lib; {
    description = "Tool to send media from online sources to Chromecast devices";
    homepage = "https://github.com/skorokithakis/catt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
    mainProgram = "catt";
  };
}
