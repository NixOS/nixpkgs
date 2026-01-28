{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "go-jsonstruct";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "go-jsonstruct";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mNZAezLKMrgnzsRikrZhmjTuF+B1ob5Bjh33voNsyCs=";
  };

  vendorHash = "sha256-5gtUZfXrob+4IJYrugjDJl6TJ1wYW5Occ1P6mRJBHjA=";

  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Go struct generator from JSON or YAML";
    homepage = "https://github.com/twpayne/go-jsonstruct";
    changelog = "https://github.com/twpayne/go-jsonstruct/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ poptart ];
  };
})
