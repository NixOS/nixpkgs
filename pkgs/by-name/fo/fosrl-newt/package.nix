{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "newt";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "newt";
    tag = finalAttrs.version;
    hash = "sha256-Kt7YCxHQEv1DeASPJtjAwzmAiWBrkf+XNs7aJEZvb+M=";
  };

  vendorHash = "sha256-QJ70q53k4EvLpiMY+Nm70QqaZk14V0Q1CrwWVSowdUU=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.newtVersion=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    # Networking failures in tests, even with __darwinAllowLocalNetworking on
    # and sandbox disabled.
    # Unclear as of 2026-04-24 whether the program works if tests are disabled.
    broken = stdenv.hostPlatform.isDarwin;
    description = "Tunneling client for Pangolin";
    homepage = "https://github.com/fosrl/newt";
    changelog = "https://github.com/fosrl/newt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      fab
      jackr
      water-sucks
    ];
    mainProgram = "newt";
  };
})
