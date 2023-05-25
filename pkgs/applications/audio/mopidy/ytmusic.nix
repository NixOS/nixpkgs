{ lib
, python3
, mopidy
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      ytmusicapi = super.ytmusicapi.overridePythonAttrs (old: rec {
        version = "0.25.1";
        src = self.fetchPypi {
          inherit (old) pname;
          inherit version;
          hash = "sha256-uc/fgDetSYaCRzff0SzfbRhs3TaKrfE2h6roWkkj8yQ=";
        };
      });
    };
  };
in python.pkgs.buildPythonApplication rec {
  pname = "mopidy-ytmusic";
  version = "0.3.8";

  src = python.pkgs.fetchPypi {
    inherit version;
    pname = "mopidy_ytmusic";
    sha256 = "6b4d8ff9c477dbdd30d0259a009494ebe104cad3f8b37241ae503e5bce4ec2e8";
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
    changelog = "https://github.com/OzymandiasTheGreat/mopidy-ytmusic/blob/v${version}/CHANGELOG.rst";
    description = "Mopidy extension for playing music from YouTube Music";
    homepage = "https://github.com/OzymandiasTheGreat/mopidy-ytmusic";
    license = licenses.asl20;
    maintainers = [ maintainers.nickhu ];
  };
}
