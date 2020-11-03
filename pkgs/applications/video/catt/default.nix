{ lib, python3 }:

let
  py = python3.override {
    packageOverrides = self: super: {
      PyChromecast = super.PyChromecast.overridePythonAttrs (oldAttrs: rec {
        version = "6.0.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "05f8r3b2pdqbl76hwi5sv2xdi1r7g9lgm69x8ja5g22mn7ysmghm";
        };
      });
    };
  };

in with py.pkgs; buildPythonApplication rec {
  pname = "catt";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vq1wg79b7855za6v6bsfgypm0v3b4wakap4rash45mhzbgjj0kq";
  };

  requiredPythonModules = [
    youtube-dl PyChromecast click ifaddr requests
  ];

  doCheck = false; # attempts to access various URLs

  meta = with lib; {
    description = "Cast All The Things allows you to send videos from many, many online sources to your Chromecast";
    homepage = "https://github.com/skorokithakis/catt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}

