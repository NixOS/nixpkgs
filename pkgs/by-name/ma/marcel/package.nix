{ lib
, fetchFromGitHub
, python3Packages
, bash
}:

python3Packages.buildPythonApplication rec {
  pname = "marcel";
  version = "0.29.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "geophile";
    repo = "marcel";
    rev = "refs/tags/v${version}";
    hash = "sha256-hUI5dUqelmRuk65s67rJXrZoPDWAcnNVIHlzxAgRExs=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  buildInputs = [
    bash
  ];

  pythonPath = with python3Packages; [
    dill
    psutil
  ];

  # The tests use sudo and try to read/write $HOME/.local/share/marcel and /tmp
  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/marcel \
      --prefix PATH : "$program_PATH:${lib.getBin bash}/bin" \
      --prefix PYTHONPATH : "$program_PYTHONPATH"
    '';

  meta = with lib; {
    description = "Modern shell";
    homepage = "https://github.com/geophile/marcel";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kud ];
    mainProgram = "marcel";
  };
}
