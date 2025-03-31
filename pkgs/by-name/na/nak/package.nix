{
  lib,
  buildGo123Module,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGo123Module rec {
  pname = "nak";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "fiatjaf";
    repo = "nak";
    tag = "v${version}";
    hash = "sha256-xFATXMK7wyEgnJXmTq9BdW27xqgXUP1Mo0m5QhFIv0I=";
  };

  vendorHash = "sha256-VkeQLWtyDfZiR0nrhmd5KCi/BIuqrFem9WhcTd3VRcc=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # Integration tests fail (requires connection to relays)
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = [ "--version" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool for Nostr things";
    homepage = "https://github.com/fiatjaf/nak";
    changelog = "https://github.com/fiatjaf/nak/releases/tag/${src.tag}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "nak";
  };
}
