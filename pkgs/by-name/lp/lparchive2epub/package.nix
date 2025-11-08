{
  fetchFromGitHub,
  lib,
  pkgs,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "lparchive2epub";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Arwalk";
    repo = "lparchive2epub";
    tag = "v${version}";
    hash = "sha256-h1i/p14Zzzr0SK+OjcCnXpsVjJl7mrbeLJ5JlnA0wPU=";
  };

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    ebooklib
    beautifulsoup4
    tqdm
    aiohttp
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  meta = {
    description = "Transform any LP from lparchive into an epub document";
    homepage = "https://github.com/Arwalk/lparchive2epub";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nsnelson ];
  };
}
