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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "maunium";
    repo = "meowlnir";
    tag = "v${version}";
    hash = "sha256-4SGTSKeB6E6VmnW4trpDGgjRsRXGN0fBye0e3BSmIkQ=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-mprhG74+jRtuGorFuoaD/oSmlThN6m6P4ygYONA/Tz4=";

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
