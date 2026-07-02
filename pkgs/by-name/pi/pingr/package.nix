{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pingr";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "cybrly";
    repo = "pingr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q4Qu2Gf6hDNwY9B0dqRJPLtbuHMgwgyauzz13Vk9rOk=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-HlMo1RYPi9GyV1WEcCrWepJLDMfsLSMgokinDwIJXuc=";

  meta = {
    description = "Tool to ping multiple hosts";
    homepage = "https://github.com/cybrly/pingr";
    changelog = "https://github.com/cybrly/pingr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pingr";
  };
})
