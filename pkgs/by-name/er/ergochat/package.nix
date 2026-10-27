{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,

  mysqlSupport ? true,
  postgresqlSupport ? true,
  sqliteSupport ? true,
}:

buildGoModule (finalAttrs: {
  pname = "ergo";
  version = "2.19.1";

  src = fetchFromGitHub {
    owner = "ergochat";
    repo = "ergo";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-yzGLOpECalSOv1zBpVkyDlHGaHSsQNsAoNa2jgLpsgM=";
  };

  tags = [
    "i18n"
  ]
  ++ lib.optional mysqlSupport "mysql"
  ++ lib.optional postgresqlSupport "postgresql"
  ++ lib.optional sqliteSupport "sqlite";

  patches = [
    # Fix systemd reload notifications
    ./0001-Fix-systemd-reload.patch
  ];

  ldflags = [
    "-X main.commit=${finalAttrs.src.rev}"
    "-X main.version=${finalAttrs.version}"
  ];

  vendorHash = null;

  passthru.tests.ergochat = nixosTests.ergochat;

  meta = {
    changelog = "https://github.com/ergochat/ergo/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Modern IRC server (daemon/ircd) written in Go";
    mainProgram = "ergo";
    homepage = "https://github.com/ergochat/ergo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lassulus
      tv
    ];
    platforms = lib.platforms.linux;
  };
})
