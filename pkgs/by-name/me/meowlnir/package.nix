{
  lib,
  buildGoModule,
  fetchFromGitHub,
  olm,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "meowlnir";
  version = "26.08";
  tag = "v0.2608.0";

  src = fetchFromGitHub {
    owner = "maunium";
    repo = "meowlnir";
    inherit tag;
    hash = "sha256-q9/pdKmJOav41P8Rm4ZzNgeEPJqui22HUbH4UBoa3tY=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-HXXAQaBaWUjnBnoiyNZB51BnPuQg9BhlDU5x2CyCW1Y=";

  doCheck = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/maunium/meowlnir";
    description = "Opinionated Matrix moderation bot";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ sumnerevans ];
    mainProgram = "meowlnir";
  };
}
