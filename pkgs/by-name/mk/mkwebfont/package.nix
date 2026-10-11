{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mkwebfont";
  version = "0.2.0-alpha10";

  src = fetchFromGitHub {
    owner = "Lymia";
    repo = "mkwebfont";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EN2p8B5bU28p9lRT3uQlwp9DDIskVRvuIFA+M6qPCPY=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-hc1oD3JS4ZJM78SpnRQL65MdG3/y5cByDW0Xa3XXojc=";

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    description = "Simple tool for turning .ttf/.otf files into webfonts";
    mainProgram = "mkwebfont";
    homepage = "https://github.com/Lymia/mkwebfont";
    changelog = "https://github.com/Lymia/mkwebfont/blob/${finalAttrs.src.rev}/RELEASES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      lpulley
    ];
  };
})
