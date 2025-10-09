{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "storj-uplink";
  version = "1.139.3";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xFoz45R0zgJCb6itrChjCk9+rip9jizJpHtqi3asSko=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-EP8ujlmm0m0wYZ9uuYjE5Aeo6r3Pg+vBMN1ZlpBdbOs=";

  ldflags = [ "-s" ];

  # Tests fail with 'listen tcp 127.0.0.1:0: bind: operation not permitted'.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = lib.licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with lib.maintainers; [ felipeqq2 ];
  };
})
