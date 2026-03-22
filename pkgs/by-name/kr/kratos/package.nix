{
  fetchFromGitHub,
  buildGoModule,
  lib,
  stdenv,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kratos";
  version = "25.4.0";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "kratos";
    rev = "v${finalAttrs.version}";
    hash = "sha256-f/K86B5h7xM7Zsbr5w2rZgsyNlCSemrBkqtMRQq/Xws=";
  };

  vendorHash = "sha256-ayL3V8TQ+9Tk2Wkhvn+Tft9AqxiFegznKXD0eBkFbhs=";

  subPackages = [ "." ];

  tags = [ "sqlite" ];

  # Pass versioning information via ldflags
  ldflags = [
    "-X github.com/ory/kratos/driver/config.Version=v${finalAttrs.version}"
  ];

  # large portion of tests fail due to:
  #     provider.go:39: building the Go binary returned error: exit status 1
  #        cannot find module providing package github.com/ory/x/jsonnetsecure/cmd: import lookup disabled by -mod=vendor
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

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "version" ];

  meta = {
    mainProgram = "kratos";
    description = "API-first Identity and User Management system that is built according to cloud architecture best practices";
    homepage = "https://www.ory.sh/kratos/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mrmebelman ];
  };
})
