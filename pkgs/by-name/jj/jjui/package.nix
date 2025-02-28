{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "jjui";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${version}";
    hash = "sha256-PAquHh3VVAhc4Tw1XkyKmwFbpLVkDRCMT+FGtqiydCA=";
  };

  vendorHash = "sha256-MxTwe0S2wvkIy8VJl1p8utTX98zfcwpNgCdnpFAMxO0=";

  postFixup = ''
    mv $out/bin/cmd $out/bin/jjui
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A TUI for Jujutsu VCS";
    homepage = "https://github.com/idursun/jjui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      adda
    ];
    mainProgram = "jjui";
  };
}
