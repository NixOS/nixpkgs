{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "pferd";
  version = "3.7.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Garmelon";
    repo = "PFERD";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-4+LlnGv/i9zDf+HeW86PJ6XsPMEkJ0JzhLr14MJ4WKM=";
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

  meta = with lib; {
    homepage = "https://github.com/Garmelon/PFERD";
    description = "Tool for downloading course-related files from ILIAS";
    license = licenses.mit;
    maintainers = with maintainers; [ _0xbe7a ];
    mainProgram = "pferd";
  };
}
