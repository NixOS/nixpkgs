{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  pname = "keto";
  version = "0.14.0";
  commit = "613779b6dad89f6fb6b4fa6968f13ede11963c97";
in
buildGoModule {
  inherit pname version commit;

  src = fetchFromGitHub {
    owner = "ory";
    repo = "keto";
    rev = "v${version}";
    hash = "sha256-DQiE7PvRnOzdRITRl7LgUDmCJO5/aUzbFdEIyiofZfU=";
  };

  vendorHash = "sha256-deQxdG3HZiMzzwTr6moILBSNeNR/3noFlJlIx1eyBZs=";

  tags = [
    "sqlite"
    "json1"
    "hsm"
  ];

  subPackages = [ "." ];

  # Pass versioning information via ldflags
  ldflags = [
    "-s"
    "-w"
    "-X github.com/ory/keto/internal/driver/config.Version=${version}"
    "-X github.com/ory/keto/internal/driver/config.Commit=${commit}"
  ];

  meta = {
    description = "ORY Keto, the open source access control server";
    homepage = "https://www.ory.sh/keto/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mrmebelman ];
  };
}
