{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  athens,
}:

buildGoModule (finalAttrs: {
  pname = "athens";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "gomods";
    repo = "athens";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vynO6J69VTJ/CYp/W7BNzFWMLQG8PHXfS90uCCIp8rA=";
  };

  vendorHash = "sha256-XM/ft+1u4KH77uOEh6ZO2YKy7jK2UUn+w7CDZeYqjFc=";

  env.CGO_ENABLED = "0";
  ldflags = [
    "-s"
    "-X github.com/gomods/athens/pkg/build.version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/proxy" ];

  postInstall = ''
    mv $out/bin/proxy $out/bin/athens
  '';

  passthru = {
    tests.version = testers.testVersion { package = athens; };
  };

  meta = {
    description = "Go module datastore and proxy";
    homepage = "https://github.com/gomods/athens";
    changelog = "https://github.com/gomods/athens/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "athens";
    maintainers = with lib.maintainers; [
      katexochen
      malt3
    ];
    platforms = lib.platforms.unix;
  };
})
