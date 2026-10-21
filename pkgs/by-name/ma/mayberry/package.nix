{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "mayberry";
  version = "0.8.29";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "SoFriendly";
    repo = "mayberry-branch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-utXzQVsrsBVy0gVbPPZASpIuH7VVfTQP8JzO//GnIqQ=";
  };

  vendorHash = "sha256-oe5njWVW7EEvxTY+HlNGqXr4ZYQ8KZDP4H3dzItUE3s=";

  subPackages = [ "cmd/branch" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/branch $out/bin/mayberry
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Federated library branch daemon for Mayberry";
    homepage = "https://joinmayberry.com/";
    changelog = "https://github.com/SoFriendly/mayberry-branch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arunoruto ];
    mainProgram = "mayberry";
  };
})
