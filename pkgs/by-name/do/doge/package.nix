{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "doge";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "Olivia5k";
    repo = "doge";
    rev = version;
    hash = "sha256-LmEbDQUZe/3lg/Ze+WUNyYfC8zMr88/rn10sL0jgbGA=";
  };

  pyproject = true;
  nativeBuildInputs = [python3Packages.setuptools];
  propagatedBuildInputs = [python3Packages.python-dateutil];

  meta = {
    homepage = "https://github.com/Olivia5k/doge";
    description = "Wow very terminal doge";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [Gonzih quantenzitrone];
    mainProgram = "doge";
  };
}
