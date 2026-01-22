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
  version = "0.0.46";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "cog";
    tag = "v${version}";
    hash = "sha256-sxZdldloFSWSRfilTuqrpMTJ3LvSLHyt5ifyZyG1Pbk=";
  };

  vendorHash = "sha256-GeJPE0UrXWYAG7G6azMYqMdq8b3dDFmJOfEY1JilzcI=";

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
