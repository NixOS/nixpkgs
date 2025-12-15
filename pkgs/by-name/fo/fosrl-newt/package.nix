{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "newt";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "newt";
    tag = version;
    hash = "sha256-R6X9DOu1iGS/a4d5kmKoBZI0L5k7S0w3SHHFQnQH/ho=";
  };

  vendorHash = "sha256-5Xr6mwPtsqEliKeKv2rhhp6JC7u3coP4nnhIxGMqccU=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.newtVersion=${version}"
  ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "-version" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tunneling client for Pangolin";
    homepage = "https://github.com/fosrl/newt";
    changelog = "https://github.com/fosrl/newt/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      fab
      jackr
      sigmasquadron
      water-sucks
    ];
    mainProgram = "newt";
  };
}
