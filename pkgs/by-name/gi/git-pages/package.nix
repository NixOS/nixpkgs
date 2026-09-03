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
  version = "0.9.1-unstable-2026-09-03";
  __structuredAttrs = true;

  src =
    (fetchFromCodeberg {
      owner = "git-pages";
      repo = "git-pages";
      rev = "507e57edbcfc0ec933a877bf26b1756ca0a61870";
      hash = "sha256-H5Fa3zhJ17Mx6ubmkhpajXQjj1CP2XRHoegjjloe9b0=";
    })
    // {
      tag = "0.9.1-unstable-2026-09-03";
    };

  patches = [
    # bugfix to allow expiring existing routes
    # remove when https://codeberg.org/git-pages/git-pages/pulls/259 is available in the release
    ./0001-feat-add-allow-retroactive-expiration-limit-config.patch
  ];

  subPackages = [ "." ];

  vendorHash = "sha256-RKn3DxX/cJoR6cXkmR9UzwF9k67NZiGt9MKba178jBU=";

  ldflags = [
    "-s"
    "-X main.versionOverride=507e57ed"
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
