{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "icoextract";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jlu5";
    repo = "icoextract";
    rev = version;
    hash = "sha256-GJCe7oFUidJt21F4NmOXspxZGRQXIjQvFjFhMYsHLjk=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    pefile
    pillow
  ];

  # tests expect mingw and multiarch
  doCheck = false;

  pythonImportsCheck = [ "icoextract" ];

  postInstall = ''
    install -Dm644 exe-thumbnailer.thumbnailer -t $out/share/thumbnailers
  '';

  meta = {
    description = "Extract icons from Windows PE files";
    homepage = "https://github.com/jlu5/icoextract";
    changelog = "https://github.com/jlu5/icoextract/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      donovanglover
    ];
    mainProgram = "icoextract";
  };
}
