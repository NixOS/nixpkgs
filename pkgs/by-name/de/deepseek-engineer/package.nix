{
  lib,
  fetchFromGitHub,
  python3Packages,
  makeWrapper,
}:

python3Packages.buildPythonApplication {
  pname = "deepseek-engineer";
  version = "2025-06-22-9aa7a2d";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tennox"; # FORK for: https://github.com/Doriandarko/deepseek-engineer/pull/16
    repo = "deepseek-engineer";
    rev = "d6f1d50a54203a69c0ffb77346c310c70bb7c393";
    hash = "sha256-11tLCMo4DHOOCG9Y+JruQgdDDo7TQVJxaPuBTzl9g5I=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3Packages; [
    openai
    prompt-toolkit
    pydantic
    python-dotenv
    rich
  ];

  postInstall = ''
    cp $src/deepseek-eng.py $out/lib/python${python3Packages.python.pythonVersion}/site-packages/
  '';

  meta = with lib; {
    description = "AI-powered software engineering assistant using DeepSeek";
    homepage = "https://github.com/Doriandarko/deepseek-engineer";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ tennox ];
    platforms = platforms.all;
  };
}
