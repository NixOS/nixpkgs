{ lib
, fetchFromGitHub
, python3
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      # Upstream is pinning releases incl. dependencies of their dependencies
      zeroconf = super.zeroconf.overridePythonAttrs (oldAttrs: rec {
        version = "0.31.0";
        src = fetchFromGitHub {
          owner = "jstasiak";
          repo = "python-zeroconf";
          rev = version;
          sha256 = "158dqay74zvnz6kmpvip4ml0kw59nf2aaajwgaamx0zc8ci1p5pj";
        };
      });

      click = super.click.overridePythonAttrs (oldAttrs: rec {
        version = "7.1.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "06kbzd6sjfkqan3miwj9wqyddfxc2b6hi7p5s4dvqjb3gif2bdfj";
        };
      });

      PyChromecast = super.PyChromecast.overridePythonAttrs (oldAttrs: rec {
        version = "9.2.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "02ig2wf2yyrnnl88r2n13s1naskwsifwgx3syifmcxygflsmjd3d";
        };
      });
    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "catt";
  version = "0.12.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Q9ePWRLwuuTG+oPKFg7xn1gj4uAVlXUxegWdyH3Yd90=";
  };

  propagatedBuildInputs = [
    click
    ifaddr
    PyChromecast
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
  };
}
