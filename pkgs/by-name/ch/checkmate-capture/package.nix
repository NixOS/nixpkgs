{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "checkmate-capture";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "bluewave-labs";
    repo = "capture";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2G/DHiNENjJPpiA7qVUcyjcGFHDbBR6ARc9FABHOVd4=";
  };

  proxyVendor = true;
  vendorHash = "sha256-XE011U2sI1kj7VnMjhZoxWakXMQGhIuFSCYUIjhefOQ=";

  ldflags = [ "-X main.Version=${finalAttrs.version}" ];

  doCheck = false;

  meta = {
    description = "A monitoring agent that collects and exposes hardware information through a RESTful API";
    homepage = "https://github.com/bluewave-labs/capture";
    changelog = "https://github.com/bluewave-labs/capture/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "capture";
    maintainers = with lib.maintainers; [ robertjakub ];
  };
})
