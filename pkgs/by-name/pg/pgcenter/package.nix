{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pgcenter";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "lesovsky";
    repo = "pgcenter";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-HSSHRMkzb0WkRAPEtG654ngnJw9rjkBq/v2Su4bUO8Y=";
  };

  vendorHash = "sha256-nHPS/iLHQwM39UYpajQRAbZcK7PxTPU0mO2HapDRFDU=";

  subPackages = [ "cmd" ];

  ldflags = [
    "-w"
    "-s"
    "-X main.gitTag=${finalAttrs.src.rev}"
    "-X main.gitCommit=${finalAttrs.src.rev}"
    "-X main.gitBranch=master"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/pgcenter
  '';

  doCheck = false;

  meta = {
    homepage = "https://github.com/lesovsky/pgcenter";
    changelog = "https://github.com/lesovsky/pgcenter/raw/v${finalAttrs.version}/doc/Changelog";
    description = "Command-line admin tool for observing and troubleshooting PostgreSQL";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "pgcenter";
  };
})
