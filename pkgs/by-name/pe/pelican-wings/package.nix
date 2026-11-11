{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  runCommand,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "pelican-wings";
  version = "1.0.0-rc.1";

  src = fetchFromGitHub {
    owner = "pelican";
    repo = "wings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TErlxIXSlmxPaEQLLqcHUm+Sum+pjI8hYve0CWpc6hc=";
  };

  vendorHash = "sha256-2Hs1SfCsf5JYIIRC0VHlfVzRx2e+xrSotqrfbCqMogo=";

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pelican/wings/system.Version=${finalAttrs.version}"
  ];

  __structuredAttrs = true;
  strictDeps = true;

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
      extraArgs = [ "--version=unstable" ];
    };
  };

  meta = {
    mainProgram = "wings";
    maintainers = with lib.maintainers; [
      oskardotglobal
      Svenum
      nullcube
      keenanweaver
    ];
    homepage = "https://pelican.dev";
    changelog = "https://github.com/pelican/wings/releases/tag/v${finalAttrs.version}";
    description = "Pelican's server control plane";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
