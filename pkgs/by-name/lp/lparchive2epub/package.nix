{
  fetchFromGitHub,
  lib,
  pkgs,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "lparchive2epub";
  version = "1.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Arwalk";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-z8/cIevqPKo7Eukk4WVxgSjzO1EYUYWD8orAdUKR8z8=";
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
