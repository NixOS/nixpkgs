{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "analyzeMFT";
  version = "3.0.7.1";

  src = fetchFromGitHub {
    owner = "rowingdude";
    repo = "analyzeMFT";
    tag = "v${version}";
    hash = "sha256-tPGLV+hzNf76sra21TB6AqkhjZIc9w5l1yLEdfE9vE4=";
  };

  meta = {
    description = "Tool to parse the MFT file from an NTFS filesystem";
    homepage = "https://github.com/rowingdude/analyzeMFT";
    changelog = "https://github.com/rowingdude/analyzeMFT/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mikehorn ];
    mainProgram = "analyzeMFT";
  };
}
