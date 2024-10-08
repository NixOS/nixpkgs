{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
let
  version = "1.12.0";
in
buildGoModule {
  pname = "gotestsum";

  # move back to stable releases when build is successful
  version = "${version}-unstable-2024-09-17";

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    rev = "2f61a73f997821b2e5a1823496e8362630e213f9";
    hash = "sha256-5zgchATcpoM4g5Mxex9wYanzrR0Pie9GYqx48toORkM=";
  };

  vendorHash = "sha256-DR4AyEhgD71hFFEAnPfSxaWYFFV7FlPugZBHUjDynEE=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X gotest.tools/gotestsum/cmd.version=${version}"
  ];

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/gotestyourself/gotestsum";
    changelog = "https://github.com/gotestyourself/gotestsum/releases/tag/v${version}";
    description = "Human friendly `go test` runner";
    mainProgram = "gotestsum";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
