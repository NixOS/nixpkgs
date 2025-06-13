{
  lib
, python3
, fetchPypi
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      click = super.click.overridePythonAttrs (oldAttrs: rec {
        version = "7.1.2";
        src = fetchPypi {
          pname = "click";
          inherit version;
          hash = "sha256-0rUlXHxjSbwb0eWeCM0SrLvWPOZJ8liHVXg6qU37axo=";
        };
          doCheck = false;
      });
      rich = super.rich.overridePythonAttrs (oldAttrs: rec {
        version = "10.16.2";
        src = fetchPypi {
          pname = "rich";
          inherit version;
          hash = "sha256-cgl0aJlg4Gwu/bVDJ/i/DNvfTq5K1ztslCE8rUBcNxs=";
        };
          doCheck = false;
          dependencies = with python3.pkgs;[
            colorama
            commonmark
          ];
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "pywhat";
  version = "5.1.0";
  pyproject = true;

  src = fetchPypi{
    inherit pname version;
    hash = "sha256-im8rMGD1zpgIgCuco+r5HhnJMuTqoDpMLlJV0LqthcQ=";
  };

  build-system = with python.pkgs; [
    poetry-core
    setuptools
  ];
  dependencies = with python.pkgs; [
    wheel
    click
    rich
  ];

  meta = with lib;{
    description = "Identify anything. pyWhat easily lets you identify emails, IP addresses, and more. Feed it a .pcap file or some text and it'll tell you what it is!";
    homepage = "https://github.com/bee-san/pyWhat";
    license = licenses.mit;
    maintainers = with maintainers; [ByteSudoer];
    mainProgram = "pywhat";
  };
}
