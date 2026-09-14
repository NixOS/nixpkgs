{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "asphalt";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jackTabsCode";
    repo = "asphalt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2PiFdz8vQmQbFw55INHD0arqGZCFCqCKkdABxGCXhvw=";
  };

  cargoHash = "sha256-w0r3wuf6oYHDPAu1aH/5AOhhdBI7g11xu7bkqlQ2euQ=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Assets-as-files tool for Roblox";
    longDescription = ''
      Asphalt is a command line tool used to upload assets to Roblox
      and easily reference them in code.  It's a modern alternative to
      [Tarmac](https://github.com/Roblox/Tarmac).
    '';
    homepage = "https://github.com/jackTabsCode/asphalt";
    changelog = "https://github.com/jackTabsCode/asphalt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "asphalt";
    maintainers = with lib.maintainers; [ mudmaster556 ];
  };
})
