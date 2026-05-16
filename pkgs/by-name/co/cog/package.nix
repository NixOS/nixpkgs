{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  cog,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "cog";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "cog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6W8b3hgBASpizFoQqP0zw3TqdPmhJ6gZFXxaPfnIiS0=";
  };

  vendorHash = "sha256-WR/dfwNBduRokPGAljnXNgA2ZKoYRGtZ3+tKBzCuXI4=";

  subPackages = [ "cmd/cli" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  env.CGO_ENABLED = 0;

  passthru.tests.version = testers.testVersion { package = cog; };

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    mv $out/bin/cli $out/bin/cog
  '';

  meta = {
    changelog = "https://github.com/grafana/cog/releases/tag/v${finalAttrs.version}";
    description = "Grafana's code generation tool";
    license = lib.licenses.asl20;
    homepage = "https://github.com/grafana/cog";
    maintainers = [
      lib.maintainers.zebradil
    ];
    mainProgram = "cog";
  };
})
