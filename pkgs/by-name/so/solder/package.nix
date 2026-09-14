{
  fetchFromGitHub,
  rustPlatform,
  lib,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "solder";
  version = "0.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fossable";
    repo = "solder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N1nggPClY4PjhvsgEQV+AVL8Ri74eXz1p/GFCPu+cbc=";
  };

  cargoHash = "sha256-au9bo7llYS8PiZvfNDC6w7HsURShKwBW9HUm12qUY30=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "solder";
    description = "Fuse shared libraries into ELFs";
    homepage = "https://github.com/fossable/solder";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ cilki ];
  };
})
