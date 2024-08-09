{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pyroscope";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "pyroscope";
    rev = "v${version}";
    hash = "sha256-spgZUjeRegvhPsj1jZCL5canL8CSSaP7gG2MMso46rQ=";
  };

  env.GOWORK = "off";

  vendorHash = "sha256-meIE8/4zgR9BHMA/48mPialhEeM4eqahdtTDukh6KtA=";

  subPackages = [ "cmd/profilecli" "cmd/pyroscope" ];

  ldflags = [
    "-extldflags"
    "-static"
    "-s"
    "-w"
    "-X=github.com/grafana/pyroscope/pkg/util/build.Branch=${src.rev}"
    "-X=github.com/grafana/pyroscope/pkg/util/build.Version=${version}"
    "-X=github.com/grafana/pyroscope/pkg/util/build.Revision=${src.rev}"
    "-X=github.com/grafana/pyroscope/pkg/util/build.BuildDate=1970-01-01T00:00:00Z"
  ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/grafana/pyroscope";
    changelog = "https://github.com/grafana/pyroscope/blob/${src.rev}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
    mainProgram = "pyroscope";
  };
}
