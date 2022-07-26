{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "helm-docs";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "norwoodj";
    repo = "helm-docs";
    rev = "v${version}";
    sha256 = "sha256-V7Qw20PPoAEXl/XAMj/WSM73fLdp/gH4G3ipx49p06o=";
  };

  vendorSha256 = "sha256-FpmeOQ8nV+sEVu2+nY9o9aFbCpwSShQUFOmyzwEQ9Pw=";

  subPackages = [ "cmd/helm-docs" ];
  ldflags = [
    "-w"
    "-s"
    "-X main.version=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/norwoodj/helm-docs";
    description = "A tool for automatically generating markdown documentation for Helm charts";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sagikazarmark ];
  };
}
