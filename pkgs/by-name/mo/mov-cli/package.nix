{ lib
, fetchFromGitHub
, ffmpeg
, fzf
, mpv
, python3
}:

let
  pname = "mov-cli";
  version = "4.4.5";
in
python3.pkgs.buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mov-cli";
    repo = "mov-cli";
    rev = version;
    hash = "sha256-Q5fzxdMEUDL1VgeTTgU76z0nksocgjyonAroP/m/Q+0=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    click
    colorama
    deprecation
    httpx
    inquirer
    krfzf-py
    lxml
    poetry-core
    pycrypto
    python-decouple
    setuptools
    six
    thefuzz
    tldextract
    toml
    typer
    unidecode
    (callPackage ./mov-cli-test.nix {})
  ];

  pythonRelaxDeps = [
    "httpx"
    "tldextract"
  ];

  makeWrapperArgs = let
    binPath = lib.makeBinPath [
      ffmpeg
      fzf
      mpv
    ];
  in [
    "--prefix PATH : ${binPath}"
  ];

  meta = with lib; {
    homepage = "https://github.com/mov-cli/mov-cli";
    description = "Cli tool to browse and watch movies";
    license = with lib.licenses; [ gpl3Only ];
    mainProgram = "mov-cli";
    maintainers = with lib.maintainers; [ baitinq ];
  };
}
