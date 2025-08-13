{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "storj-uplink";
  version = "1.134.2";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DNxbJ+vw6a2yxbc6y/h+o4C7yhh5laCr2XIdBmjvAyc=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-ZteKOH6t2C96pm1u3J5GLXgWVdM77FjRqg6bYqIh1wQ=";

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
