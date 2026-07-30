{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "silverbullet-cli";
  version = "2.6.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "silverbulletmd";
    repo = "silverbullet";
    rev = finalAttrs.version;
    hash = "sha256-vHRLOYsFsQjpDu3mlbJxWq+P07JnHdO54myFb2Rm18s=";
  };

  vendorHash = "sha256-SvMPyJbSVrj+lwXrNh2WEYNI41oqlzchFxCtXvIl4/4=";
  subPackages = [ "cmd/cli" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/silverbullet-cli
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "silverbullet-cli version";
  };

  meta = {
    changelog = "https://github.com/silverbulletmd/silverbullet/blob/${finalAttrs.version}/website/CHANGELOG.md";
    description = "CLI for SilverBullet, an open-source, self-hosted, offline-capable Personal Knowledge Management (PKM) web application";
    homepage = "https://silverbullet.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aorith
      gleber
    ];
    mainProgram = "silverbullet-cli";
  };
})
