{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "apftool-rs";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "suyulin";
    repo = "afptool-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bu6iaKGoaj+EKLJ7ulYdKyKSQuaX++zXnyiwBNUKz3Q=";
  };

  cargoHash = "sha256-/AJ5UCrh3RYklrfQ7zb1N9n2rXsdPrvH+QGYnKGU1dc=";

  meta = {
    description = "About Tools for Rockchip image unpack tool";
    mainProgram = "apftool-rs";
    homepage = "https://github.com/suyulin/afptool-rs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ colemickens ];
    platforms = lib.platforms.linux;
  };
})
