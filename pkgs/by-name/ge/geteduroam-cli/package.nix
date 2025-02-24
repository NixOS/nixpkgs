{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule rec {
  pname = "geteduroam-cli";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "geteduroam";
    repo = "linux-app";
    tag = version;
    hash = "sha256-9+IjrHg536/6ulj94CBhYWY0S3aNA7Ne4JQynMmsLxE=";
  };

  vendorHash = "sha256-9SNjOC59wcEkxJqBXsgYClHKGH7OFWk3t/wMPLANAy0=";

  subPackages = [
    "cmd/geteduroam-cli"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/geteduroam-cli";
  versionCheckProgramArg = [ "--version" ];
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
