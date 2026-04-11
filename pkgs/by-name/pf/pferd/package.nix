{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pferd";
  version = "3.8.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Garmelon";
    repo = "PFERD";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-ea/9+9zRlRfblPYfI40IPjHWPneXaAqtRp0Cb/FT+lg=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    beautifulsoup4
    rich
    keyring
    certifi
  ];

  meta = {
    homepage = "https://github.com/Garmelon/PFERD";
    description = "Tool for downloading course-related files from ILIAS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _0xbe7a ];
    mainProgram = "pferd";
  };
})
