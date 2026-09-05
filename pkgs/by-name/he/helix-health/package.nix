{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  helix,
}:

buildGoModule (finalAttrs: {
  pname = "helix-health";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "gunererd";
    repo = "helix-health";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fuU8LVV30QMqpYvw1It1YBtgZ1iYmOdELOhwXk9wYio=";
  };

  vendorHash = "sha256-BStOOu6GxqKToSA9cEyIzJdgK2T7PPhfReuacFnh2fU=";

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    wrapProgram $out/bin/helix-health \
      --prefix PATH : ${lib.makeBinPath [ helix ]}
  '';

  meta = {
    description = "Interactive TUI for viewing and searching Helix editor's health information";
    homepage = "https://github.com/gunererd/helix-health";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gunererd ];
    mainProgram = "helix-health";
  };
})
