{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "geminicommit";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "tfkhdyt";
    repo = "geminicommit";
    rev = "refs/tags/v${version}";
    hash = "sha256-wfSYR458uK47JtsiNrD3f6bD5HcfFf5WxlKdx8oLidY=";
  };

  vendorHash = "sha256-N1c0b+eGaIvXJ4p3ovDypGRIn8wCwemFoNm9CvItz6E=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "CLI that writes your git commit messages for you with Google Gemini AI";
    homepage = "https://github.com/tfkhdyt/geminicommit";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tfkhdyt ];
    mainProgram = "geminicommit";
  };
}
