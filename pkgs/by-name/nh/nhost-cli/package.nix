{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nhost-cli";
  version = "1.29.3";

  src = fetchFromGitHub {
    owner = "nhost";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-CboqEkN8/a/cE6SQ9m1neQznvO88M6ppWtEc7m/EEjI=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=v${version}"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/nhost
  '';

  # require network access
  checkFlags = [ "-skip=^TestMakeJSONRequest$" ];

  meta = {
    description = "Tool for setting up a local development environment for Nhost";
    homepage = "https://github.com/nhost/cli";
    changelog = "https://github.com/nhost/cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "nhost";
  };
}
