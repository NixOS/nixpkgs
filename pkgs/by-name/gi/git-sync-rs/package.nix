{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  git,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-sync-rs";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "colonelpanic8";
    repo = "git-sync-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8s+zqbidenwqS+854dyV2CmobU9LeW/KRCFubvXzFlY=";
  };

  cargoHash = "sha256-ngdovTM3SvMniOtgfFuCYc7lBUTcGBmHl3IeTfLZKfA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  nativeCheckInputs = [
    git
  ];

  postInstall = ''
    ln -s $out/bin/git-sync-rs $out/bin/git-sync-on-inotify
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Automatic git repository synchronization with file watching";
    homepage = "https://github.com/colonelpanic8/git-sync-rs";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ imalison ];
    mainProgram = "git-sync-rs";
  };
})
