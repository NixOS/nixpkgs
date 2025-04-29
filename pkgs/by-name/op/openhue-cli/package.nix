{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "openhue-cli";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "openhue";
    repo = "openhue-cli";
    rev = finalAttrs.version;
    hash = "sha256-q+bn47cad98SAIZeR9b9w2c3uXnubIL7fa45BW9cbZ4=";
  };

  vendorHash = "sha256-lqIzmtFtkfrJSrpic79Is0yGpnLUysPQLn2lp/Mh+u4=";

  env.CGO_ENABLED = 0;

  rev = "f279046f988829b2a38a03f8fd4fb5cebd460dbb";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.rev}"
  ];

  postInstall = ''
    mv $out/bin/openhue-cli $out/bin/openhue
  '';

  meta = with lib; {
    changelog = "https://github.com/openhue/openhue-cli/releases/tag/${finalAttrs.version}";
    description = "CLI for interacting with Philips Hue smart lighting systems";
    homepage = "https://github.com/openhue/openhue-cli";
    mainProgram = "openhue";
    maintainers = with maintainers; [ madeddie ];
    license = licenses.asl20;
  };
})
