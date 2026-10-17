{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  writableTmpDirAsHomeHook,
  git,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitst";
  version = "0.1.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dfallman";
    repo = "gitst";
    tag = finalAttrs.version;
    hash = "sha256-3lLf+gEKddbG7plgdEFlHTnsQM8hoXHbYsp+YSHyCkE=";
  };

  cargoHash = "sha256-lHlpKYDUhYYFj6Ljlda8tFdvu1x3bGUXNi/GI0YjpGg=";

  nativeBuildInputs = [
    makeWrapper
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    git
  ];

  postInstall = ''
    wrapProgram $out/bin/gitst \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Real-time, glanceable interactive git status for the terminal";
    homepage = "https://github.com/dfallman/gitst";
    changelog = "https://github.com/dfallman/gitst/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "gitst";
  };
})
