{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cacert,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "asphalt";
  version = "2.0.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "jackTabsCode";
    repo = "asphalt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1SYRjKPYkQaCntsKiiMg0v4kzxnQ6Pns6fk5cO1ImVA=";
  };

  cargoHash = "sha256-R4pNHy/4BmmbKzuYWM31Iih626AL46lLe1BY3d57FZI=";

  # reqwest/rustls refuses to build a client without a CA bundle.
  nativeCheckInputs = [ cacert ];

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
