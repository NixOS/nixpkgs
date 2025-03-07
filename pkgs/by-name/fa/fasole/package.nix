{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fasole";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "ProggerX";
    repo = "fasole";
    rev = "v${version}";
    hash = "sha256-qcCJgz/YXfd8+9ST1U4YFxLLd25D8HrfZzsDGpKgCdM=";
  };

  vendorHash = "sha256-V5jqsNy4Pu1AKikIZqEXERdggwBe3gXKMJVmgivVT6A=";

  meta = {
    description = "Minimalist's todo-list";
    homepage = "https://github.com/ProggerX/fasole";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ proggerx ];
    mainProgram = "fasole";
  };
}
