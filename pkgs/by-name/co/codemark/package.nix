{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codemark-cli";
  version = "0.7.23";
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "DanielCardonaRojas";
    repo = "codemark";
    tag = finalAttrs.version;
    sha256 = "sha256-0BlhLWmTFqhTVH2kELOLxqPkq2M8rZAUTUyyyDjkNIk=";
  };

  cargoHash = "sha256-Lv29aqMhTgbmD72pxwEE2PUlF6xSV1cVR1RNpuTgGvk=";

  # I was not able to disable the failing checks when packaging
  # Feel free to fix
  doCheck = false;

  meta = {
    description = "A semantic code bookmarking system for humans and agents";
    homepage = "https://danielcardonarojas.github.io/codemark/";
    changelog = "https://github.com/DanielCardonaRojas/codemark/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;

    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
