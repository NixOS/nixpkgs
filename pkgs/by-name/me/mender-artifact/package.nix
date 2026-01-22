{
  fetchFromGitHub,
  buildGoModule,
  pkg-config,
  lib,
  openssl,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "mender-artifact";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "mendersoftware";
    repo = "mender-artifact";
    tag = finalAttrs.version;
    hash = "sha256-J1aOX3CSxkTnGnMGOa7bdhM/pPh5JIRxWkgr8bGRQFY=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  vendorHash = null;

  checkPhase =
    let
      disabledTestPaths = [
        # Nearly entire test module fails for different reasons
        "github.com/mendersoftware/mender-artifact/cli"
      ];
      disabledTest = [
        # Expected nil, but got: &exec.Error{Name:"/usr/local/sbin/bin/ls"
        "TestGetBinaryPath"
      ];
      patternDisabledTestPaths = builtins.concatStringsSep "|" disabledTestPaths;
      patternDisabledTest = builtins.concatStringsSep "|" disabledTest;
    in
    ''
      runHook preCheck

      go test $(go list ./... | grep -v -E '${patternDisabledTestPaths}') -skip=$'${patternDisabledTest}'

      runHook postCheck
    '';

  ldflags = [
    "-X github.com/mendersoftware/mender-artifact/cli.Version=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    homepage = "https://mender.io";
    changelog = "https://github.com/mendersoftware/mender-artifact/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Library for managing Mender artifact files";
    mainProgram = "mender-artifact";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ skohtv ];
  };
})
