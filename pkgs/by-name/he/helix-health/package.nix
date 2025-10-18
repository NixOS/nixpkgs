{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  makeWrapper,
  helix,
}:

buildGo125Module (finalAttrs: {
  pname = "helix-health";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "gunererd";
    repo = "helix-health";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zfdensdAOo4VtJWl3k5o/zfeu/9DddW85aq6VI1ZZRw=";
  };

  vendorHash = "sha256-BStOOu6GxqKToSA9cEyIzJdgK2T7PPhfReuacFnh2fU=";

  # Temporarily patch go.mod to work with available Go version
  postPatch = ''
    substituteInPlace go.mod \
      --replace "go 1.25.2" "go 1.25.1"
  '';

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
