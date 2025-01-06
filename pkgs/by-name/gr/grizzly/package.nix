{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "grizzly";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9NtJHavlkuu8qSQI4FvXDOKfD1WjNzVqGDd8/8Fo3DE=";
  };

  vendorHash = "sha256-lioFmaFzqaxN1wnYJaoHA54to1xGZjaLGaqAFIfTaTs=";

  subPackages = [ "cmd/grr" ];

  meta = {
    description = "Utility for managing Jsonnet dashboards against the Grafana API";
    homepage = "https://grafana.github.io/grizzly/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nrhtr ];
    platforms = lib.platforms.unix;
    mainProgram = "grr";
  };
}
