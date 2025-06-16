{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule rec {
  pname = "rcon-cli";
  version = "1.7.0";

  src = fetchFromGitHub {
    tag = "${version}";
    owner = "itzg";
    repo = "rcon-cli";
    hash = "sha256-1dexjVfbqTzq9RLhVPn0gRcdJTa/AFj8BiQLoD0/L5c=";
  };

  vendorHash = "sha256-xq1Z6cgUqXXVzc/j54Nul6xAXa5gKh3NeenQoMW+Xpg=";
  subPackages = [ "." ];

  nativeCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^([0-9.]+)$"
    ];
  };

  meta = {
    description = "A little RCON cli based on james4k's RCON library for golang";
    homepage = "https://github.com/itzg/rcon-cli";
    changelog = "https://github.com/itzg/rcon-cli/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      link00000000
    ];
    mainProgram = "rcon-cli";
  };
}
