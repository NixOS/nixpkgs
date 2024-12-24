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
  version = "0.33.1";

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "rattler-build";
    rev = "refs/tags/v${version}";
    hash = "sha256-yceScRfZuMVnNVNVg3Xs+jU3spdFn0hPMmwMLaYzkNE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-eJH7a+9asSPDv0gBwvLc4zssJGCY2jAfVKKOWb3oQ/Q=";

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
