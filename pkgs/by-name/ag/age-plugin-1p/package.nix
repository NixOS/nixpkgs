{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "age-plugin-1p";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Enzime";
    repo = "age-plugin-1p";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QYHHD7wOgRxRVkUOjwMz5DV8oxlb9mmb2K4HPoISguU=";
  };

  vendorHash = "sha256-WrdwhlaqciVEB2L+Dh/LEeSE7I3+PsOTW4c+0yOKzKY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Use SSH keys from 1Password with age";
    mainProgram = "age-plugin-1p";
    homepage = "https://github.com/Enzime/age-plugin-1p";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ Enzime ];
  };
})
