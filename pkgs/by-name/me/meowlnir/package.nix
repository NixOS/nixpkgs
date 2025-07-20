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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "maunium";
    repo = "meowlnir";
    tag = "v${version}";
    hash = "sha256-TKt6uwj3RdhSEjGnWmYybJFaQ82qf3tXY4PPUAm6juQ=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-rFk4QUAI/Brclt/X/T7O0T6v2dTxpqbNLtoi0twYliw=";

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
