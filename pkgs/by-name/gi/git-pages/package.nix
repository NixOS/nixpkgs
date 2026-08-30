{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  nix-update-script,
  versionCheckHook,
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

  subPackages = [ "." ];

  vendorHash = "sha256-NNIkzgRki2rtCVUnnhT44rEBcMZYiJPmsXySpxiHYR0=";

  ldflags = [
    "-s"
    "-X main.versionOverride=${finalAttrs.src.tag}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scalable static site server for Git forges (like GitHub Pages or Netlify";
    homepage = "https://codeberg.org/git-pages/git-pages";
    changelog = "https://codeberg.org/git-pages/git-pages/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "git-pages";
  };
})
