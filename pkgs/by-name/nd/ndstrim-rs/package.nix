{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ndstrim-rs";
  version = "0.2.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Nemris";
    repo = "ndstrim-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KgtejBbFg6+klc8OpCs1CIb+7uVPCtP0/EM671vxauk=";
  };

  cargoHash = "sha256-wRMMWeZDk9Xt3263pq20Qioy1x8egiPhuoPxmpNTq8M=";

  meta = {
    description = "Trim the excess padding found in Nintendo DS(i) ROMs";
    homepage = "https://github.com/Nemris/ndstrim-rs";
    changelog = "https://github.com/Nemris/ndstrim-rs/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ thiagokokada ];
    mainProgram = "ndstrim";
  };
})
