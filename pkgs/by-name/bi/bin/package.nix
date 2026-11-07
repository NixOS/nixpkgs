{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  nix-update-script,
  stdenv,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "bin";
  version = "0.29.4";

  src = fetchFromGitHub {
    owner = "marcosnils";
    repo = "bin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NsP+b5d25E44L64VDulWjTkRvOJeE9qhiVtMSRyP+gU=";
  };

  vendorHash = "sha256-/i1bfoo+s7VN1LIubqByebzbS++9JMjdvqr/2eH+ugY=";

  __structuredAttrs = true;

  # Tests start local HTTP servers
  __darwinAllowLocalNetworking = true;

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # Without a default path, loading the config prompts for a download directory
    export BIN_CONFIG=$(mktemp)
    echo '{"default_path": "/tmp", "bins": {}}' >"$BIN_CONFIG"

    for shell in bash fish zsh; do
      installShellCompletion --cmd bin \
        --"$shell" <("$out"/bin/bin completion "$shell")
    done

    # installShellCompletion doesn't support PowerShell
    mkdir -p "$out"/share/powershell
    "$out"/bin/bin completion powershell >"$out"/share/powershell/bin.ps1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Effortless binary manager";
    homepage = "https://github.com/marcosnils/bin";
    changelog = "https://github.com/marcosnils/bin/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "bin";
  };
})
