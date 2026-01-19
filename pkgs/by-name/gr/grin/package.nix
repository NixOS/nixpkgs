{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "grin";
  version = "1.3.0-unstable-2023-08-30";
  namePrefix = "";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matthew-brett";
    repo = "grin";
    rev = "00e11ebf17bbb37dc33d282eac1282c0bcc07e82";
    hash = "sha256-0lrCOXFb2v0hCxWd9O7ysbn8CjPd8NHOJhARYzJJcYg=";
  };

  build-system = [ python3Packages.setuptools ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  meta = {
    homepage = "https://github.com/matthew-brett/grin";
    description = "Grep program configured the way I like it";
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.sjagoe ];
  };
}
