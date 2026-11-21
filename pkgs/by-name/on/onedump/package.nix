{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, stdenv
,
}:

buildGoModule rec {
  pname = "onedump";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "liweiyi88";
    repo = "onedump";
    rev = "v${version}";
    hash = "sha256-hGEuQNTAqxJZ8CxtQbzcyn4fXnwua6jKv98rDf4AJXM=";
  };

  vendorHash = "sha256-vxLtOajsHHWkxKTW7+nAakb29VwzXbn2A70dUL/X1Ag=";

  # Tests require external binaries like mysqlbinlog and running database instances
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd onedump \
      --bash <($out/bin/onedump completion bash) \
      --fish <($out/bin/onedump completion fish) \
      --zsh <($out/bin/onedump completion zsh)
  '';

  meta = {
    description = "Database administration tool for streamlined backup and restore across multiple databases and storage destinations";
    longDescription = ''
      Onedump is an open-source database administration tool designed to streamline
      backup and restore tasks across multiple databases and storage destinations.

      Key features:
      - Native MySQL dumper with zero dependencies
      - Support for MySQL and PostgreSQL databases
      - Multiple storage backends: local filesystem, AWS S3, Google Drive, Dropbox, SFTP
      - MySQL binlog backup and restore capabilities
      - MySQL slow log parser
      - Resumable and concurrent SFTP file transfers
      - Configurable via YAML with support for loading configs from S3
      - Cron job scheduling support
      - Slack notifications
    '';
    homepage = "https://github.com/liweiyi88/onedump";
    changelog = "https://github.com/liweiyi88/onedump/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ htuscher ];
    mainProgram = "onedump";
  };
}
