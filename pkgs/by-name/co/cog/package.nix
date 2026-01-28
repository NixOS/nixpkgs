{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  cog,
  stdenv,
}:

buildGoModule rec {
  pname = "cog";
  version = "0.0.47";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "cog";
    tag = "v${version}";
    hash = "sha256-gbM/PknM8ZC4BJx2OymLSuQO+DndB3f1Wx0zvep9tn0=";
  };

  vendorHash = "sha256-Uf6XwwhWl6dzJJFeDgIoQU0zZ2QFjzEWwv+q9YazTxs=";

  subPackages = [ "cmd/cli" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  env.CGO_ENABLED = 0;

  passthru.tests.version = testers.testVersion { package = cog; };

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    mv $out/bin/cli $out/bin/cog
  '';

  meta = {
    changelog = "https://github.com/grafana/cog/releases/tag/v${version}";
    description = "Grafana's code generation tool";
    license = lib.licenses.asl20;
    homepage = "https://github.com/grafana/cog";
    maintainers = [
      lib.maintainers.zebradil
    ];
    mainProgram = "cog";
  };
}
