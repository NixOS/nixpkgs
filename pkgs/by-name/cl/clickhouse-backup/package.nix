{
  buildGoModule,
<<<<<<< HEAD
  fetchFromGitHub,
  lib,
  ps,
  stdenv,
  versionCheckHook,
=======
  clickhouse-backup,
  fetchFromGitHub,
  lib,
  testers,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildGoModule rec {
  pname = "clickhouse-backup";
<<<<<<< HEAD
  version = "2.6.41";
=======
  version = "2.6.39";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Altinity";
    repo = "clickhouse-backup";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-LBwmdGcQuDu0tr9c67bboBzv6ypxzYRU36Z76lL94yo=";
  };

  vendorHash = "sha256-UxbQ/Q4HsTBkbIMBdeKns6t8tZnfdBRaHDMOA2RYDLI=";
=======
    rev = "v${version}";
    hash = "sha256-fx300EyGm9iy4kozcffh8KZz/EYF6yqkdNLSqW1dYQg=";
  };

  vendorHash = "sha256-MwyjjEePxcwcESfBhmFtYy8aOI50HL7x05cJyGk5gGg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-X main.version=${version}"
  ];

  postConfigure = ''
    export CGO_ENABLED=0
  '';

<<<<<<< HEAD
  preCheck = ''
    export PATH=${ps}/bin:$PATH
  '';

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [ "-skip=TestParseCallback" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Tool for easy ClickHouse backup and restore using object storage for backup files";
    mainProgram = "clickhouse-backup";
    homepage = "https://github.com/Altinity/clickhouse-backup";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ devusb ];
=======
  passthru.tests.version = testers.testVersion {
    package = clickhouse-backup;
  };

  meta = with lib; {
    description = "Tool for easy ClickHouse backup and restore using object storage for backup files";
    mainProgram = "clickhouse-backup";
    homepage = "https://github.com/Altinity/clickhouse-backup";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
