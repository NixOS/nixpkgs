{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dismap";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "zhzyker";
    repo = "dismap";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-YjjiS6iLIQvrPS378v2nyrgwWBJ9YtDeNTPz0ze05mU=";
  };

  vendorHash = "sha256-GnchyE2TswvjYlehhMYesZruTTwyTorfR+17K0RXXFY=";

  meta = {
    description = "Asset discovery and identification tools";
    mainProgram = "dismap";
    homepage = "https://github.com/zhzyker/dismap";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
