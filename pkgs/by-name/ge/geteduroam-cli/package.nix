{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "geteduroam-cli";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "geteduroam";
    repo = "linux-app";
    tag = finalAttrs.version;
    hash = "sha256-fmkTenN5F2FEimYUQi6JVUGmHcnVJvE9Giur+xTl+1s=";
  };

  vendorHash = "sha256-kmBuyIs5S6h51+tF7vhY92o6VP+M7QI9AwuZSQUwjXg=";

  subPackages = [
    "cmd/geteduroam-cli"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/geteduroam-cli";
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
    changelog = "https://github.com/geteduroam/linux-app/releases/tag/${finalAttrs.version}";
  };
})
