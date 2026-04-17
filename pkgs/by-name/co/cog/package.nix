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
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "cog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eIvesUCvIluSFZuiU6NI1JUrpuRGi0t2cz5uNkvE6/c=";
  };

  vendorHash = "sha256-OrFRYCWb//ga1R+QIkg4aMhQYAFOAxRPi5IvGjUL6I4=";

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
