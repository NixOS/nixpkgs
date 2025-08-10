{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "storj-uplink";
  version = "1.133.5";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MvaA8AkoP4FszEEM33QKDt5zeXMZ3XDt5uU1t6C6Q1I=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-N1rEEM+oH2VVOvg9c8gICQ1aDO9FS/faVbQl0kj1jYM=";

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
