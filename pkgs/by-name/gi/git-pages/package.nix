{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  fetchpatch,
  nix-update-script,
  versionCheckHook,
  formats,
  coreutils,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "git-pages";
  version = "0.9.1-unstable-2026-08-27";
  __structuredAttrs = true;

  src =
    (fetchFromCodeberg {
      owner = "git-pages";
      repo = "git-pages";
      rev = "017649481612cfe12b6127ac8cac3afdcd7ab796";
      hash = "sha256-QUtWbPQzyiRN1wSlekoly4H8cTKvUP/egLAc+mBQOk8=";
    })
    // {
      tag = "0.9.1-unstable-2026-08-27";
    };

  patches = [
    # bugfix to avoid creating parent directory on start
    # remove when https://codeberg.org/git-pages/git-pages/pulls/258 is available in the release
    (fetchpatch {
      name = "mkdirall-parent-dir-create.patch";
      url = "https://codeberg.org/git-pages/git-pages/commit/507e57edbcfc0ec933a877bf26b1756ca0a61870.patch";
      hash = "sha256-1CjU4yGmDOmYsxo3U44Cg2xLJkrmUOX5ZXTycdLs6OE=";
    })
  ];

  subPackages = [ "." ];

  vendorHash = "sha256-RKn3DxX/cJoR6cXkmR9UzwF9k67NZiGt9MKba178jBU=";

  ldflags = [
    "-s"
    "-X main.versionOverride=01764948"
  ];

  doInstallCheck = false;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru = {
    tests = { inherit (nixosTests) git-pages-modular; };
    updateScript = nix-update-script { };
    services.default = {
      imports = [
        (lib.modules.importApply ./service.nix { inherit formats coreutils; })
      ];
      git-pages.package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Scalable static site server for Git forges (like GitHub Pages or Netlify";
    homepage = "https://codeberg.org/git-pages/git-pages";
    changelog = "https://codeberg.org/git-pages/git-pages/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "git-pages";
  };
})
