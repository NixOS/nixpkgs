{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stakk";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "glennib";
    repo = "stakk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tbzy8+dt5nxGODhng1Mb07PiEesIMZ0DROPLZBDWusI=";
  };

  cargoHash = "sha256-t/O+EXeuGZXQn1fwVnjF2rAleDUWFTwIaSF+NSGrX4w=";

  useNextest = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };
  __structuredAttrs = true;

  meta = {
    description = "Bridge Jujutsu (jj) bookmarks to GitHub stacked pull requests";
    homepage = "https://github.com/glennib/stakk";
    changelog = "https://github.com/glennib/stakk/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      voidlily
      Br1ght0ne
    ];
    mainProgram = "stakk";
  };
})
