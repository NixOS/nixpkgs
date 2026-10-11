{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "dynacat";
  version = "3.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Panonim";
    repo = "dynacat";
    tag = finalAttrs.version;
    hash = "sha256-RGR5C94PDv6XJek8zs1uQdhZNANnDN+csYGEZIDHhYU=";
  };

  vendorHash = "sha256-mpEeOPYhqJABNxheSHYWngyYJQJJTqtiW7dlm+O4LpI=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Panonim/dynacat/internal/dynacat.buildVersion=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Self-hosted dashboard focused on dynamic updates and integrations, forked from Glance";
    homepage = "https://github.com/Panonim/dynacat";
    changelog = "https://github.com/Panonim/dynacat/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ andreszb ];
    mainProgram = "dynacat";
  };
})
