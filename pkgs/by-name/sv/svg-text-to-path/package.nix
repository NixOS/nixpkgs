{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "svg-text-to-path";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "paulzi";
    repo = "svg-text-to-path";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B6/8BbJ75jeFpTFIzL6BtMNCRL9181KxrUkaP9u9odA=";
  };

  npmDepsHash = "sha256-x593WtqC9Y8AweL6LOr228p1eAc1rI4C+6Ev1K3pUJo=";
  npmPackFlags = [ "--ignore-scripts" ];
  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Convert svg nodes to vector font-free elements";
    homepage = "https://github.com/paulzi/svg-text-to-path";
    maintainers = with lib.maintainers; [ ulysseszhan ];
    license = lib.licenses.mit;
    mainProgram = "svg-text-to-path";
    platforms = lib.platforms.unix;
  };
})
