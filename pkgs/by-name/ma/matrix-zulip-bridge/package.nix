{ lib
, fetchpatch
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

  patches = [
    (fetchpatch {
      url = "https://github.com/GearKite/MatrixZulipBridge/pull/2/commits/d1a8a277cad16520d26a6dd8159d988ea4d58aa6.patch";
      hash = "sha256-e7+irftBqL02zst9aCqBcOdavqKT3/usLlZQUonpjHU=";
    })
  ];

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
