{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "mufetch";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "ashish0kumar";
    repo = "mufetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iYqLfxJDh0k4tCYfEP40sf3oFLtkvThsJ7ub9KThDNE=";
  };

  vendorHash = "sha256-aXSNM6z/U+2t0aGtr5MIjTb7huAQY/yRf6Oc1udLJYI=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ashish0kumar/mufetch/cmd.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/ashish0kumar/mufetch/releases/tag/v${finalAttrs.version}";
    description = "Neofetch-style CLI for music metadata with album art display";
    homepage = "https://github.com/ashish0kumar/mufetch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ashish0kumar ];
    mainProgram = "mufetch";
    platforms = lib.platforms.unix;
  };
})
