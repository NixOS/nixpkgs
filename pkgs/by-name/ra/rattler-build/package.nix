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
  version = "0.32.1";

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "rattler-build";
    rev = "refs/tags/v${version}";
    hash = "sha256-jVYck9UCeOJlRaQsdk3GTPZLYZbRjoDH4NbEdwNr6mM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8TK5xtKAMv5QCbq+he/ptnQf+pbrR5UfNb76qTh99+c=";

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
