{
  fetchFromGitHub,
  buildGoModule,
  lib,
  stdenv,
}:
let
  pname = "kratos";
  version = "25.4.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ory";
    repo = "kratos";
    rev = "v${version}";
    hash = "sha256-f/K86B5h7xM7Zsbr5w2rZgsyNlCSemrBkqtMRQq/Xws=";
  };

  vendorHash = "sha256-ayL3V8TQ+9Tk2Wkhvn+Tft9AqxiFegznKXD0eBkFbhs=";

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
