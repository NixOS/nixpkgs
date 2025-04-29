{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "age-plugin-1p";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Enzime";
    repo = "age-plugin-1p";
    tag = "v${version}";
    hash = "sha256-QYHHD7wOgRxRVkUOjwMz5DV8oxlb9mmb2K4HPoISguU=";
  };

  vendorHash = "sha256-WrdwhlaqciVEB2L+Dh/LEeSE7I3+PsOTW4c+0yOKzKY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Use SSH keys from 1Password with age";
    mainProgram = "age-plugin-1p";
    homepage = "https://github.com/Enzime/age-plugin-1p";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ Enzime ];
  };
}
