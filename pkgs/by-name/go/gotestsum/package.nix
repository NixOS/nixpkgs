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
  inherit version;

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    rev = "v${version}";
    hash = "sha256-eve3G5JhvaUapAenoIDn2ClHqljpviVpmJl4ZaAUqTs=";
  };

  vendorHash = "sha256-JT9x1xuWKTiMQ8jxZuW+ZwRRQt2Y4Lk8peESvgTgimc=";
  proxyVendor = true;

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
