{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  nix-update-script,
  stdenvNoCC,
}:

buildGoModule (finalAttrs: {
  pname = "bin";
  version = "0.24.3";

  src = fetchFromGitHub {
    owner = "marcosnils";
    repo = "bin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9+ZV5kWQuBqpQGcOHATlPq0ffQGFjrCWCGz5zwFoqF8=";
  };

  vendorHash = "sha256-1YY15GQ1p5megAtlwwKi+IMiXlitf9vuSPIoh7YsSvQ=";

  ldflags = [ "-s" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    export HOME=$(mktemp -d)
    mkdir -p "$HOME"/.config/bin
    printf '{
      "default_path": "/tmp",
      "bins": {}
    }' >"$HOME"/.config/bin/config.json

    for shell in bash fish zsh; do
      installShellCompletion --cmd bin \
        --"$shell" <("$out"/bin/bin completion "$shell")
    done

    # installShellCompletion doesn't support PowerShell
    mkdir -p "$out"/share/powershell
    "$out"/bin/bin completion powershell >"$out"/share/powershell/bin.ps1

    rm -rf "$HOME"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Effortless binary manager";
    homepage = "https://github.com/marcosnils/bin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "bin";
  };
})
