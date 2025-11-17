{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "gotify-cli";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "gotify";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-GwPIGWEpj5GjGV9bz3LctZctHQe+Vywoc1piNb9vAAw=";
  };

  vendorHash = "sha256-+G0LWlPiDcYmEou4gpoIU/OAjzQ3VSHftM1ViG9lhYM=";

  postInstall = ''
    mv $out/bin/cli $out/bin/gotify
  '';

  ldflags = [
    "-X main.Version=${version}"
    "-X main.Commit=${version}"
    "-X main.BuildDate=1970-01-01"
  ];

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/gotify/cli";
    description = "Command line interface for pushing messages to gotify/server";
    maintainers = [ ];
    mainProgram = "gotify";
  };
}
