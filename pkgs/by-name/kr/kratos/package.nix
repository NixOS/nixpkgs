{
  fetchFromGitHub,
  buildGoModule,
  lib,
  stdenv,
}:
let
  pname = "kratos";
  version = "1.3.1";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ory";
    repo = "kratos";
    rev = "v${version}";
    hash = "sha256-FJrBwjWBYwoiy8rWXn+jaVc1b35So1Rb9SjkUlNwAqE=";
  };

  vendorHash = "sha256-zZwunp/433oIYI5ZA3Pznq9jfvIZE5ZUJKxboVef8g0=";

  subPackages = [ "." ];

  tags = [ "sqlite" ];

  # Pass versioning information via ldflags
  ldflags = [
    "-X github.com/ory/kratos/driver/config.Version=${version}"
  ];

  doCheck = false;

  preBuild = ''
    # Patch shebangs
    files=(
       test/e2e/run.sh
       script/testenv.sh
       script/test-envs.sh
       script/debug-entrypoint.sh
    )
    patchShebangs "''${files[@]}"

    # patchShebangs doesn't work for this Makefile, do it manually
    substituteInPlace Makefile --replace-fail '/usr/bin/env bash' '${stdenv.shell}'
  '';

  meta = {
    mainProgram = "kratos";
    description = "API-first Identity and User Management system that is built according to cloud architecture best practices";
    homepage = "https://www.ory.sh/kratos/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mrmebelman ];
  };
}
