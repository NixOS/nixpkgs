{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "jjui";
<<<<<<< HEAD
  version = "0.9.8";
=======
  version = "0.9.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-YEEcSaIm21IUp7EFdYvDG2h55YIqzghYdGxdXmZnp9I=";
  };

  vendorHash = "sha256-2TlJJY/eM6yYFOdq8CcH9l2lFHJmFrihuGwLS7jMwJ0=";
=======
    hash = "sha256-sLOQa9IoRcYEXcShiE/vdjJknQcDwefVwHii63MPXpw=";
  };

  vendorHash = "sha256-SMeS1FHc8UdXaxF9A8eYFkWQIM0hgWfBpuX+DsBglcw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [ "-X main.Version=${finalAttrs.version}" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for Jujutsu VCS";
    homepage = "https://github.com/idursun/jjui";
    changelog = "https://github.com/idursun/jjui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      adda
    ];
    mainProgram = "jjui";
  };
})
