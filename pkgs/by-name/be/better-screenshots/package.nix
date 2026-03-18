{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "better-screenshots";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snhsish";
    repo = "better-screenshots";
    tag = "v${version}";
    hash = "sha256-bms9+RuzuEh6kBV7S4yjwXWBLUSPuu0ucD/riFm07E4=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    click
    pillow
    toml
    pyyaml
    requests
  ];

  doCheck = false;

  meta = {
    description = "Screenshot tool with image and background customizations plus configurable cloud uploads.";
    mainProgram = "better-screenshots";
    homepage = "https://github.com/snhsish/better-screenshots";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ snhsish ];
  };
}
