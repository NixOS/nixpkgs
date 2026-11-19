{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  cacert,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qlue-ls";
  version = "3.13.1";

  src = fetchFromGitHub {
    owner = "qlever-dev";
    repo = "qlue-ls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-th72T0Xu+IXJaz3q4W4ROR7IqQHcNWfb+rUvXbxKTeA=";
  };

  cargoHash = "sha256-MPxdX4Bb+Oo+YBhKFjB+58ZEYC4/olx6+Dgs4rZxPN0=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
  ];

  nativeCheckInputs = [
    cacert
  ];

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  versionCheckKeepEnvironment = [ "HOME" ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/qlever-dev/qlue-ls/releases/tag/v${finalAttrs.version}";
    description = "Language server for SPARQL";
    homepage = "https://github.com/qlever-dev/qlue-ls";
    license = lib.licenses.mit;
    mainProgram = "qlue-ls";
    teams = with lib.teams; [ ngi ];
  };
})
