{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "resetti";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "tesselslate";
    repo = "resetti";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H4LkXTjXCuOUB9x24lEc4ofCKkAn1Eac2zMPIAgxkSE=";
  };

  vendorHash = "sha256-lhcCN5r1TSB95Y0pEoKAvftR0DMxtII3g+YOKT8I1qk=";

  ldflags = [ "-s" ];

  meta = {
    description = "Utility macros for Minecraft speedrunning";
    homepage = "https://github.com/tesselslate/resetti";
    changelog = "https://github.com/tesselslate/resetti/releases/tag/${finalAttrs.src.tag}";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jess ];
    mainProgram = "resetti";
  };
})
