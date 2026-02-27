{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "autotiling-rs";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "ammgws";
    repo = "autotiling-rs";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-jeakiO28LM223qyPqZ4tdozQbNxJ6vEEl2Avk8ZBwlA=";
  };

  cargoHash = "sha256-ytViAnvcU99hr9Ki9AOtcmBRYFtuBdWeRe2Z00+WRGs=";

  meta = {
    description = "Autotiling for sway (and possibly i3)";
    homepage = "https://github.com/ammgws/autotiling-rs";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "autotiling-rs";
  };
})
