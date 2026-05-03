{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "alpaca-proxy";
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "samuong";
    repo = "alpaca";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yz90kJGyf2iA3LCj9d/oG5rLVUZVI//cqI6w67iV9Tc=";
  };

  vendorHash = "sha256-3A88gc8j0OrxBIAFBNlz3Np5CV9xpwwIDCnnfXyBj4Q=";

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
