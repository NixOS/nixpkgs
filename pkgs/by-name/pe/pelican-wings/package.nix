{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  runCommand,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "wings";
  version = "1.0.0-beta29";

  src = fetchFromGitHub {
    owner = "pelican";
    repo = "wings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rKrv3VfP9cHSJq4fPXBV5wzdTQP4slE88wqGFbGyr3A=";
  };

  vendorHash = "sha256-TCTlA+yvfxi0RH0etWJl7B6fbrKVuWZFRFvf7ejrfnA=";

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pelican/wings/system.Version=${finalAttrs.version}"
  ];

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "wings version";
        version = "v${finalAttrs.version}";
      };
      help = runCommand "wings-help-test" { } ''
        ${lib.getExe finalAttrs.finalPackage} --help
        touch $out
      '';
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(.*-beta.*)$"
        "--version=unstable"
      ];
    };
  };

  meta = {
    mainProgram = "wings";
    maintainers = [ lib.maintainers.oskardotglobal ];
    homepage = "https://github.com/pelican/wings";
    changelog = "https://github.com/pelican/wings/releases/tag/${finalAttrs.version}";
    description = "Pelican's server control plane";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };

  __structuredAttrs = true;
  strictDeps = true;
})
