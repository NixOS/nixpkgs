{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "alpaca-proxy";
  version = "2.0.11";

  src = fetchFromGitHub {
    owner = "samuong";
    repo = "alpaca";
    tag = "v${finalAttrs.version}";
    hash = "sha256-74JQ9ltJ7+sasySgNN3AaXlBILP7VgFN06adoNJG+Bc=";
  };

  vendorHash = "sha256-N9qpyCQg6H1v/JGJ2wCxDX+ZTM9x6/BM6wQ26xC+dlE=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.BuildVersion=v${finalAttrs.version}"
  ];

  postInstall = ''
    # executable is renamed to alpaca-proxy, to avoid collision with the alpaca python application
    mv $out/bin/alpaca $out/bin/alpaca-proxy
  '';

  meta = {
    description = "HTTP forward proxy with PAC and NTLM authentication support";
    homepage = "https://github.com/samuong/alpaca";
    changelog = "https://github.com/samuong/alpaca/releases/tag/v${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ _1nv0k32 ];
    mainProgram = "alpaca-proxy";
  };
})
