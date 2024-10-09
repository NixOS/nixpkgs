{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "criticality_score";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "ossf";
    repo = "criticality_score";
    rev = "v${version}";
    hash = "sha256-w6IRJJX0xxpoirpuMw7oCv55WFqZ+oopvVo6CP/oPL0=";
  };

  proxyVendor = true;
  subPackages = [
    "cmd/collect_signals"
    "cmd/criticality_score"
    "cmd/csv_transfer"
    "cmd/enumerate_github"
    "cmd/scorer"
  ];
  vendorHash = "sha256-I0LpmNBRn18cMVoOroH/ITaonvgbQak67RguSsYxCNY=";

  meta = with lib; {
    description = "Gives criticality score for an open source project";
    homepage = "https://github.com/ossf/criticality_score";
    changelog = "https://github.com/ossf/criticality_score/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ nathanielbrough ];
  };
}
