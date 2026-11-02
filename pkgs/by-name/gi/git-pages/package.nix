{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  nix-update-script,
  versionCheckHook,
  formats,
  coreutils,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "git-pages";
  version = "0.10.1";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "git-pages";
    repo = "git-pages";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8FWb7cXCyx7Rt+UetmyNo3TTiF778JxlHGWyLpcUBfI=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-Q6uFwlFP7p/Nh88Fever0QDG9/YXO3r6dkGcgKr+35E=";

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
