{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "matrix-zulip-bridge";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GearKite";
    repo = "MatrixZulipBridge";
    rev = "v${version}";
    hash = "sha256-5bDqZb8xx5SjThZUSmOcctwo6B15cjkIwA26QNfED2A=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'markdownify = "^0.10"' 'markdownify = "^0.11"' \
      --replace 'ruamel-yaml = ">=0.16, <0.18"' 'ruamel-yaml = ">=0.16, <0.19"' \
      --replace 'zulip-emoji-mapping = "^1.0.1"' 'zulip-emoji-mapping = "*"' \
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
    zulip-emoji-mapping
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
