{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "smassh";
  version = "3.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kraanzu";
    repo = "smassh";
    rev = "v${version}";
    sha256 = "sha256-QE7TFf/5hdd2W2EsVbn3gV/FundhJNxHqv0JWV5dYDc=";
  };

  dependencies = with python3.pkgs; [
    (
      textual.overrideAttrs (oldAttrs: rec {
        version = "0.52.1";
        src = fetchPypi {
          pname = "textual";
          inherit version;
          sha256 = "sha256-QjLlwrQj7Xxjuq62AwNV4U4d4bnfCWyWVbaKHmDk3l8=";
        };
      })
    )
    click
    appdirs
    requests
  ];

  build-system = with python3.pkgs; [
    poetry-core
  ];

  meta = with lib; {
    description = "Smassh your Keyboard, TUI Edition";
    homepage = "https://github.com/kraanzu/smassh";
    changelog = "https://github.com/kraanzu/smassh/blob/main/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kanielrkirby ];
    mainProgram = "smassh";
    descriptionLong = ''
    Smassh is a TUI based typing test application inspired by MonkeyType
    -- A very popular online web-based typing application

    Smassh tries to be a full fledged typing test experience but not missing out on looks and feel!
    '';
  };
}
