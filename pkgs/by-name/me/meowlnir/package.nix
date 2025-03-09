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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "maunium";
    repo = "meowlnir";
    tag = "v${version}";
    hash = "sha256-Fzi9KI6bPrmKMku176rAnLpfVcAjYlKUQ8MiSQB9hpU=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-G1+KDssamPRFlGs/moBk0qJDT/IctiKgnM+mVfCDMwg=";

  doCheck = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/maunium/meowlnir";
    description = "Opinionated Matrix moderation bot";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
    mainProgram = "meowlnir";
  };
}
