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
  version = "25.12";
  tag = "v0.2512.0";

  src = fetchFromGitHub {
    owner = "maunium";
    repo = "meowlnir";
    inherit tag;
    hash = "sha256-nmuS04qFzY/9kjvNqgI2TpyAzaGGat9FhS4zRL+QvzY=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-gZYRcxAf1eYqSRVruqDVIbCkoHWnyIkeGc0pF3eVIBQ=";

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
