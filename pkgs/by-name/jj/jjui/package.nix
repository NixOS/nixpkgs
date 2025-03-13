{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "jjui";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${version}";
    hash = "sha256-+1KVKevY7aWkAbbHQi06whh3keibdSVEykYDItSMi4I=";
  };

  vendorHash = "sha256-MxTwe0S2wvkIy8VJl1p8utTX98zfcwpNgCdnpFAMxO0=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A TUI for Jujutsu VCS";
    homepage = "https://github.com/idursun/jjui";
    changelog = "https://github.com/idursun/jjui/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      adda
    ];
    mainProgram = "jjui";
  };
}
