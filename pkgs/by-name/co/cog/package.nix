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
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "cog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QMYqrPmJjDmB7Kc9HZN9ypqtiwF9Cah3fnj4iMM8W4Y=";
  };

  vendorHash = "sha256-KOk8SvajH98jjvoPZPC4UAsF5tXKjn1xcVq5juQXQVA=";

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
