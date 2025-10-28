{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "ndstrim";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Nemris";
    repo = "ndstrim";
    rev = "v${version}";
    hash = "sha256-KgtejBbFg6+klc8OpCs1CIb+7uVPCtP0/EM671vxauk=";
  };

  cargoHash = "sha256-wRMMWeZDk9Xt3263pq20Qioy1x8egiPhuoPxmpNTq8M=";

  meta = with lib; {
    description = "Trim the excess padding found in Nintendo DS(i) ROMs";
    homepage = "https://github.com/Nemris/ndstrim";
    changelog = "https://github.com/Nemris/ndstrim/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thiagokokada ];
    mainProgram = "ndstrim";
  };
}
