{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "mullvad-compass";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "Ch00k";
    repo = "mullvad-compass";
    tag = finalAttrs.version;
    hash = "sha256-OhaXabjkimeMXty6msqDJVvnWXu8G6jWz/E2x7ZYrDI=";
  };

  vendorHash = "sha256-gEdtoJjCa0nVyi7T4zzv6xUDTQCYFi4ANFaqXGeqcsI=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Find the best Mullvad VPN server to connect to";
    homepage = "https://github.com/Ch00k/mullvad-compass";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "mullvad-compass";
  };
})
