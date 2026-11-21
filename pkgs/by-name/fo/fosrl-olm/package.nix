{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "olm";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "olm";
    tag = finalAttrs.version;
    hash = "sha256-Ggf0OJc0NECrWELIQqROEBfwINxNGVfXqeJya5js1Fc=";
  };

  vendorHash = "sha256-Ep4aowzqaD9vZ9rObXZEtUSWpuzxEyonlOC8p8g5HhY=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.olmVersion=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  __structuredAttrs = true;

  meta = {
    description = "Tunneling client for Pangolin";
    homepage = "https://github.com/fosrl/olm";
    changelog = "https://github.com/fosrl/olm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jackr
      water-sucks
    ];
    mainProgram = "olm";
  };
})
