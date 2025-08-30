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
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "colonelpanic8";
    repo = "git-sync-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4UwQp1HKdr30qK1xWcJ2xApfTNrdNOxfL26BJlvxknQ=";
  };

  cargoHash = "sha256-YQFx3m48GHTH5t4QScnC4OLOJRq5fDdjkr7ws8aoOXw=";

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
