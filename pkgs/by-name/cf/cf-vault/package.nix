{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
  cf-vault,
}:
buildGoModule (finalAttrs: {
  pname = "cf-vault";
  version = "0.0.18";

  src = fetchFromGitHub {
    owner = "jacobbednarz";
    repo = "cf-vault";
    rev = finalAttrs.version;
    sha256 = "sha256-vp9ufjNZabY/ck2lIT+QpD6IgaVj1BkBRTjPxkb6IjQ=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/jacobbednarz/cf-vault/cmd.Rev=${finalAttrs.version}"
  ];

  vendorHash = "sha256-7qFB1Y1AnqMgdu186tAXCdoYOhCMz8pIh6sY02LbIgs=";

  passthru.tests.version = testers.testVersion {
    package = cf-vault;
    command = "cf-vault version";
  };

  meta = {
    description = "Tool for managing your Cloudflare credentials, securely";
    homepage = "https://github.com/jacobbednarz/cf-vault/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ viraptor ];
    mainProgram = "cf-vault";
  };
})
