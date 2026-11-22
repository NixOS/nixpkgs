{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "brook";
  version = "20270101";

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = "brook";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-OIuEJFGOUkvHjxI4FPKWU65VFvgXG0+pu9giGJXYS0w=";
  };

  vendorHash = "sha256-974jdNwpQbdTbYjY/6KaicwNclizeIQXfyMZI3v/9aA=";

  meta = {
    homepage = "https://github.com/txthinking/brook";
    description = "Cross-platform Proxy/VPN software";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ xrelkd ];
    mainProgram = "brook";
  };
})
