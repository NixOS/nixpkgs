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
  version = "25.10";
  tag = "v0.2510.0";

  src = fetchFromGitHub {
    owner = "maunium";
    repo = "meowlnir";
    tag = tag;
    hash = "sha256-Hrmkka05PSNnt0tcIBBkGy43QzCphMkSibXqcLMIE1w=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-VFgw3CeUnvuUZfmqRD1liRAy8NXexcR/8mBJ1m1PR2c=";

  doCheck = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/maunium/meowlnir";
    description = "Opinionated Matrix moderation bot";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
    mainProgram = "meowlnir";
  };
}
