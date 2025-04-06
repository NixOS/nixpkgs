{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule rec {
  pname = "geteduroam-cli";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "geteduroam";
    repo = "linux-app";
    tag = version;
    hash = "sha256-2iAvE38r3iwulBqW+rrbrpNVgQlDhhcVUsjZSOT5P1A=";
  };

  vendorHash = "sha256-b06wnqT88J7etNTFJ6nE9Uo0gOQOGvvs0vPNnJr6r4Q=";

  subPackages = [
    "cmd/geteduroam-cli"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/geteduroam-cli";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "CLI client to configure eduroam";
    mainProgram = "geteduroam-cli";
    homepage = "https://github.com/geteduroam/linux-app";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ viperML ];
    platforms = lib.platforms.linux;
    changelog = "https://github.com/geteduroam/linux-app/releases/tag/${version}";
  };
}
