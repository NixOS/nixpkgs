{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  sqlite,
  vulkan-loader,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "repeater";
  version = "0.1.9";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "shaankhosla";
    repo = "repeater";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vkiDJ9hGEa9PCaNjgGJAvAFGUxXJK04ezvXyAmJB3bk=";
  };

  cargoHash = "sha256-/ttQpk9JnSRhE/VOJlz60LpV1PJ/spzXQ1EPLcox1mw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    sqlite
    vulkan-loader
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "Spaced repetition, in your terminal";
    homepage = "https://github.com/shaankhosla/repeater";
    changelog = "https://github.com/shaankhosla/repeater/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gwg313 ];
    mainProgram = "repeater";
  };
})
