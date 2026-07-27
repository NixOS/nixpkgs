{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "silverbullet-cli";
  version = "2.9.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "silverbulletmd";
    repo = "silverbullet";
    rev = finalAttrs.version;
    hash = "sha256-XQ0OKkiQrrmwmdGXk3dcim/2qosenF3EG2lkglQQ/iY=";
  };

  vendorHash = "sha256-8zZlhVptJq8y3k2DBghJ0lPNcIcaZYkrxN67b6dNBPs=";
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
