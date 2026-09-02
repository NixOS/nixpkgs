{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "red-table";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "volker-schukai";
    repo = "red-table";
    tag = finalAttrs.version;
    hash = "sha256-wloknsKIfYd1DVJ81SWc3y6+AB0cZgr7MtcAek2TyfY=";
  };

  cargoHash = "sha256-6ALtsU9/sRVy05GSKIp8f6rCsaaojHE6T/Hp2xuQ5ic=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "red-table";
    description = ''
      Fast keyboard-driven terminal image browser for browsing,
      comparing, and selecting large image collections
    '';
    longDescription = ''
      red-table is a performance-first terminal image browser for large image collections.
      It provides a searchable, scrollable thumbnail grid controlled entirely from the keyboard,
      including arrow keys and Vim-style h, j, k, and l navigation.
    '';
    homepage = "https://github.com/volker-schukai/red-table";
    downloadPage = "https://github.com/volker-schukai/red-table/releases/tag/${finalAttrs.src.tag}";
    changelog = "https://github.com/volker-schukai/red-table/commits/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    identifiers = {
      cpeParts = lib.meta.cpeFullVersionWithVendor "volker-schukai" finalAttrs.version;
      purlParts = {
        type = "github";
        namespace = "volker-schukai";
        name = "red-table";
        version = finalAttrs.version;
      };
    };
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
})
