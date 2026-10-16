{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "age-plugin-keystore";
  version = "1.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "arouene";
    repo = "age-plugin-keystore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-op9gJPfYSwaLyq6UpnKtu7MqBVtPMPnJBvZTibqG+p8=";
  };

  vendorHash = "sha256-+RwWLDqnSOv5/lBa89jbWQq+BcFHxP5to5/zVfYt1fs=";

  ldflags = [
    "-s"
    "-w"
  ];

  env = {
    CGO_ENABLED = "0";
  };

  # Tests need dbus and a secret service
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Age plugin that stores X25519 or PQ Hybrid private keys in Linux Keyrings using the Secret Service D-Bus API";
    homepage = "https://github.com/arouene/age-plugin-keystore";
    changelog = "https://github.com/arouene/age-plugin-keystore/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marie ];
    mainProgram = "age-plugin-keystore";
  };
})
