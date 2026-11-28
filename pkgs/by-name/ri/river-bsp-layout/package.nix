{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "river-bsp-layout";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "areif-dev";
    repo = "river-bsp-layout";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GfNCMYm97XMKm4oBkUZp1L28IqUL17kiDOEL4C9ZF78=";
  };

  cargoHash = "sha256-iooSaG/eWcNnQ5GJrUaSWoulA9zuGZ0CqgWuj/9t44s=";

  meta = {
    homepage = "https://github.com/areif-dev/river-bsp-layout";
    description = "Binary space partition / grid layout manager for River WM";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ areif-dev ];
    mainProgram = "river-bsp-layout";
    platforms = lib.platforms.linux;
  };
})
