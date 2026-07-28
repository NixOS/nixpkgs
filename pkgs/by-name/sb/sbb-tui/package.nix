{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "sbb-tui";
  version = "1.15.0";
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "Necrom4";
    repo = "sbb-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bYIIMFUogowywYmXNWRobmo7etbHqwOV8eHmaxz1AUg=";
  };

  vendorHash = "sha256-K4DOu3rfSlKAa5JNKCzWWpnWZlXXxtN5Po7p1Spqe1w=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI client for Switzerland's public transport timetables, inspired by SBB/CFF/FFS app";
    homepage = "https://github.com/Necrom4/sbb-tui";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tomasrivera ];
    mainProgram = "sbb-tui";
  };
})
