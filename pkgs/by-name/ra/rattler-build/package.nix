{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,

  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "rattler-build";
  version = "0.31.1";

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "rattler-build";
    rev = "refs/tags/v${version}";
    hash = "sha256-Xwa7cqj5RRmHrHOPcekbRNE6jsl2wcJeKlzOvzOGdaM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ux4R6BLXt52IWv7I3aJ7dubvWzz9WeDjplRlE2QTNyY=";

  doCheck = false; # test requires network access

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = [ "-V" ];

  meta = {
    description = "Universal package builder for Windows, macOS and Linux";
    homepage = "https://github.com/prefix-dev/rattler-build";
    changelog = "https://github.com/prefix-dev/rattler-build/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "rattler-build";
  };
}
