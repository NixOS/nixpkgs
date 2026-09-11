{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "metapac";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "ripytide";
    repo = "metapac";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6Nw4CUTx0/KcHHguRrUH6Sa+DZhPJqdsTEeVBb0eEqw=";
  };

  cargoHash = "sha256-hUd9qWXXErOyJV0mjmkMUb8KPuUhp1XI3GNYwpt1Xow=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-backend declarative package manager";
    longDescription = ''
      `metapac` allows you to maintain a consistent set of packages
      across multiple machines.  It also makes setting up a new system
      with your preferred packages from your preferred package
      managers much easier.
    '';
    homepage = "https://github.com/ripytide/metapac";
    changelog = "https://github.com/ripytide/metapac/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "metapac";
  };
})
