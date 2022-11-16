{ lib
, python3
, mopidy
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      ytmusicapi = super.ytmusicapi.overridePythonAttrs (old: rec {
        version = "0.22.0";
        format = "setuptools";
        src = old.src.override {
          inherit version;
          hash = "sha256-CZ4uoW4UHn5C+MckQXysTdydaApn99b0UCnF5RPb7DI=";
        };
      });
    };
  };
in python.pkgs.buildPythonApplication rec {
  pname = "mopidy-ytmusic";
  version = "0.3.7";

  src = python.pkgs.fetchPypi {
    inherit version;
    pname = "Mopidy-YTMusic";
    sha256 = "0gqjvi3nfzkqvbdhihzai241p1h5p037bj2475cc93xwzyyqxcrq";
  };

  propagatedBuildInputs = [
    (mopidy.override { pythonPackages = python.pkgs; })
    python.pkgs.ytmusicapi
    python.pkgs.pytube
  ];

  pythonImportsCheck = [ "mopidy_ytmusic" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Mopidy extension for playing music from YouTube Music";
    homepage = "https://github.com/OzymandiasTheGreat/mopidy-ytmusic";
    license = licenses.asl20;
    maintainers = [ maintainers.nickhu ];
  };
}
