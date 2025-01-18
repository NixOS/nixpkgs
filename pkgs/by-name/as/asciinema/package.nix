{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "asciinema";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "asciinema";
    rev = "v${version}";
    hash = "sha256-UegLwpJ+uc9cW3ozLQJsQBjIGD7+vzzwzQFRV5gmDmI=";
  };

  build-system = [ python3Packages.setuptools ];

  postPatch = ''
    substituteInPlace tests/pty_test.py \
      --replace-fail "python3" "${python3Packages.python.interpreter}"
  '';

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  meta = with lib; {
    description = "Terminal session recorder and the best companion of asciinema.org";
    homepage = "https://asciinema.org/";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
    mainProgram = "asciinema";
  };
}
