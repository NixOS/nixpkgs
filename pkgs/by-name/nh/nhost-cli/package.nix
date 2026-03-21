{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nhost-cli";
  version = "1.31.3";

  src = fetchFromGitHub {
    owner = "nhost";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hUltJCehmlIDRLdJNGC/Oyjl6rnQHzjxSjrQEaDCdAo=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/nhost
  '';

  # require network access
  checkFlags = [ "-skip=^TestMakeJSONRequest$" ];

  meta = {
    description = "Tool for setting up a local development environment for Nhost";
    homepage = "https://github.com/nhost/cli";
    changelog = "https://github.com/nhost/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "nhost";
  };
})
