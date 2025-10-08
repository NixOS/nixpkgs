{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "storj-uplink";
  version = "1.137.5";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QvmCtW8szGoo7sNHbChvtkTOUOxf1TQHQCoYeV1pN9o=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-YWqrdjB6lOOdt99XOrh27O1gza6qZ2Xn+9XfTnwOJsw=";

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
