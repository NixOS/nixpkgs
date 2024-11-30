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
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "rattler-build";
    rev = "refs/tags/v${version}";
    hash = "sha256-MTCtDE0oX9vUIwO62sKkCGleooHU28Lq8eXzwiNPDMo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QONzLC1LvKkbslXZQTqxb6RHgsoUX21MXXyLVtTSvxc=";

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
