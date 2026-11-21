{
  buildGo127Module,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "godevccu";
  version = "0.12.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "godevccu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zKMYdmZbeJbHqq+VV2lcNgm7amcwl3rMcHR0EknI7VY=";
  };

  vendorHash = null;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/SukramJ/godevccu/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Virtual HomeMatic CCU with XML-RPC & JSON-RPC servers";
    homepage = "https://github.com/SukramJ/godevccu";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
    mainProgram = "godevccu";
  };
})
