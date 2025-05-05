{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "broom";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "a-camarillo";
    repo = "broom";
    rev = "v${version}";
    hash = "sha256-a2hUgYpiKm/dZWLRuCZKuGStmZ/7jDtLRAjd/B57Vxw=";
  };

  vendorHash = "sha256-zNklqGjMt89b+JOZfKjTO6c75SXO10e7YtQOqqQZpnA=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Interactive CLI tool for managing local git branches";
    homepage = "https://github.com/a-camarillo/broom";
    license = licenses.mit;
    maintainers = with maintainers; [ a-camarillo ];
    mainProgram = "broom";
  };
}
