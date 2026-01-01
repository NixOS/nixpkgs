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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "maunium";
    repo = "meowlnir";
    tag = "v${version}";
    hash = "sha256-S0GrM8uKfWJh0/oAQp2f7P+yj99N0bovCNscM8b7tB8=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-gzigJ2gg9jaREbFdX+38sUV8I/gcB5x+lYaABnS2Mbk=";

  doCheck = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/maunium/meowlnir";
    description = "Opinionated Matrix moderation bot";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ sumnerevans ];
=======
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/maunium/meowlnir";
    description = "Opinionated Matrix moderation bot";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "meowlnir";
  };
}
