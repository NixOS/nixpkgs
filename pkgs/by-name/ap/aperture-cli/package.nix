{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "aperture-cli";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "aperture-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RxXEHd73j+Cef9GZk3pKjv7T3a60lGSi4vreKDW3JUU=";
  };

  vendorHash = "sha256-OEBKpEwaQ9ehSHDlkZjRoP2gRQByJK9Ikpe2nhIKzAg=";

  subPackages = [ "cmd/aperture" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.buildVersion=v${finalAttrs.version}"
  ];

  postInstall = ''
    ln -s aperture $out/bin/aperture-cli
  '';

  meta = {
    description = "Agentic coding launcher for Aperture";
    homepage = "https://github.com/tailscale/aperture-cli";
    changelog = "https://github.com/tailscale/aperture-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ Masrepus ];
    mainProgram = "aperture";
  };
})
