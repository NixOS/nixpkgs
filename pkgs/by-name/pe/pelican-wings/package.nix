{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  runCommand,
}:
buildGoModule (finalAttrs: {
  pname = "wings";
  version = "1.0.0-beta25";

  src = fetchFromGitHub {
    owner = "pelican-dev";
    repo = "wings";
    tag = finalAttrs.version;
    sha256 = "sha256-EFWK8VYYMw1rU7ktAdEL7XRO3dFYW/2hPgOlsfWInHA=";
  };

  vendorHash = "sha256-q1dcgf+F5MI5cV9Z6ZQDGnqxWsaT8XCWJO0Co81rKo8=";

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pelican-dev/wings/system.Version=${finalAttrs.version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    help = runCommand "wings-help-test" { } ''
      ${lib.getExe finalAttrs.finalPackage} --help
      touch $out
    '';
  };

  meta = {
    mainProgram = "wings";
    maintainers = [ lib.maintainers.oskardotglobal ];
    homepage = "https://github.com/pelican-dev/wings";
    changelog = "https://github.com/pelican-dev/wings/releases/tag/${finalAttrs.version}";
    description = "Pelican's server control plane";
    license = lib.licenses.mit;
  };

  __structuredAttrs = true;
})
