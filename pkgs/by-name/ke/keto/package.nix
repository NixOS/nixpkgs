{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  pname = "keto";
  version = "25.4.0";
  commit = "613779b6dad89f6fb6b4fa6968f13ede11963c97";
in
buildGoModule {
  inherit pname version commit;

  src = fetchFromGitHub {
    owner = "ory";
    repo = "keto";
    rev = "v${version}";
    hash = "sha256-2DktCLYOj2azYBAhMVuqfU7QQ+eC3qDLtcp+fPljFAg=";
  };

  vendorHash = "sha256-+zHvIf3CBMMqKVmQYzMRGQg9iGf9Khnhpgt95lA0BBA=";

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
