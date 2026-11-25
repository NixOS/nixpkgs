{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "kobodl";
  version = "0.14.1";
  src = fetchFromGitHub {
    owner = "subdavis";
    repo = "kobo-book-downloader";
    rev = "0.14.1";
    hash = "sha256-i8YHrflBqB2S3cDzSd02NWnLCIZ1ipwGY1XeOKKAL+k=";
  };

  pyproject = true;

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    click
    dataclasses-json
    flask
    pycryptodome
    requests
    tabulate
    setuptools
  ];

  # "dataclasses" is built into Nix's python
  pythonRemoveDeps = [ "dataclasses" ];

  # Allow the versions present in Nix (they work)
  pythonRelaxDeps = [
    "dataclasses-json"
    "flask"
    "setuptools"
    "tabulate"
  ];

  meta = {
    description = "Kobo Book Downloader";
    homepage = "https://github.com/subdavis/kobo-book-downloader";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.fauxmight ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "kobodl";
  };
}
