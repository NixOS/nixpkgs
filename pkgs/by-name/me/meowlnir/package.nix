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
  version = "26.09";
  tag = "v0.2609.0";

  src = fetchFromGitHub {
    owner = "maunium";
    repo = "meowlnir";
    inherit tag;
    hash = "sha256-UM1ArJqV5TFm2XM2htDzbSCQnpAhoHe0ybsmb1oP5NY=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-0DZTXfwG+UXXQtD3kzEYCgKmiK8U4b6GNdrEZ+nY/LU=";

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
