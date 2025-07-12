{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-callvis";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "ofabry";
    repo = "go-callvis";
    rev = "v${version}";
    hash = "sha256-gCQjxJH03QAg6MZx5NJUJR6tKP02ThIa5BGN6A/0ejM=";
  };

  vendorHash = "sha256-IS8lkDBy7Y/qAaDxmWRfrVQEF9OFo7VofqSNgNTEQQw=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Build errors in github.com/goccy/go-graphviz/internal/ccall when format hardening is enabled:
  #   cc1: error: '-Wformat-security' ignored without '-Wformat' [-Werror=format-security]
  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Visualize call graph of a Go program using Graphviz";
    mainProgram = "go-callvis";
    homepage = "https://github.com/ofabry/go-callvis";
    license = licenses.mit;
    maintainers = with maintainers; [ meain ];
  };
}
