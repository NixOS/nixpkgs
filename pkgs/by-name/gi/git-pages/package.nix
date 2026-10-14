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
  version = "0.9.1";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "git-pages";
    repo = "git-pages";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4yQ3RRJbOfMaqjJJ6CRRN7TuaYY8ScLXxMZPd4tWPwk=";
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

  vendorHash = "sha256-NNIkzgRki2rtCVUnnhT44rEBcMZYiJPmsXySpxiHYR0=";

  ldflags = [
    "-s"
    "-X main.versionOverride=${finalAttrs.src.tag}"
  ];

  doInstallCheck = true;
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
