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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "maunium";
    repo = "meowlnir";
    tag = "v${version}";
    hash = "sha256-ig803e4onU3E4Nj5aJo2+QfwZt12iKIJ7fS/BjXsojc=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-+P7tlpGTo9N+uSn22uAlzyB36hu3re+KfOe3a/uzLZE=";

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
