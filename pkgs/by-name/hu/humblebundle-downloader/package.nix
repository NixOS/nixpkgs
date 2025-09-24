{
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "humblebundle-downloader";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xtream1101";
    repo = "humblebundle-downloader";
    tag = version;
    hash = "sha256-fLfAGDKn6AWHJKsgQ0fBYdN6mGfZNrVs9n6Zo9VRgIY=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    parsel
    requests
  ];

  meta = {
    description = "Download your Humble Bundle Library";
    mainProgram = "hbd";
    homepage = "https://github.com/xtream1101/humblebundle-downloader";
    changelog = "https://github.com/xtream1101/humblebundle-downloader/blob/${src.tag}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
