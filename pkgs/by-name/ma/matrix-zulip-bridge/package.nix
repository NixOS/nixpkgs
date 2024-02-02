{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "matrix-zulip-bridge";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GearKite";
    repo = "MatrixZulipBridge";
    rev = "v${version}";
    hash = "sha256-sGXu9juhW8AMULznAJwtPstgoaqt5aYYcOf8BJJaE9g=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'emoji = "^2.9"' 'emoji = "^2"' \
  '';

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    bidict
    coloredlogs
    emoji
    markdown
    markdownify
    mautrix
    pytest-cov
    python-dotenv
    ruamel-yaml
    zulip
  ];

  pythonImportsCheck = [ "matrixzulipbridge" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/GearKite/MatrixZulipBridge";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
    mainProgram = "matrix-zulip-bridge";
  };
}
