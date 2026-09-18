{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "lazycommit";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "m7medvision";
    repo = "lazycommit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ygWGR7CNLV5Z9MOl45Y57aay8PYt/5PnYZCJCJy0fFg=";
  };

  vendorHash = "sha256-4OPCUWXxsAnzxsqZPHhjvhxQQf5Knm7nGqrdjH4I4YY=";

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  # Error reading config file: open /nix/build/nix-53143-2282724270/.home/.config/.lazycommit.yaml: no such file or directory
  checkFlags = lib.optional stdenv.hostPlatform.isDarwin "-skip=^TestSetEndpoint_Validation$";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.buildSource=nix"
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v([0-9.]+)$"
      ];
    };
  };

  meta = {
    description = "Simple cli for generating git commits";
    homepage = "https://github.com/m7medvision/lazycommit";
    changelog = "https://github.com/m7medvision/lazycommit/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      m7medvision
    ];
    mainProgram = "lazycommit";
  };
})
