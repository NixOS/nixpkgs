{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  makeWrapper,
}:

buildGoModule rec {
  pname = "relcheck";
  version = "1.8.12";
  revision = "08e4c78ce043e149a546dc286ee216fde27289bb";

  src = fetchFromGitHub {
    owner = "anttiharju";
    repo = "relcheck";
    rev = revision;
    hash = "sha256-mEPUtkOihRehaMg+qKSlmtFEmcHEacLvPt2ne0GZjDg=";
  };

  vendorHash = null;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/relcheck" \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.revision=${revision}"
    "-X main.version=${version}"
    "-X main.time=2025-11-09T12:47:32Z"
  ];

  meta = {
    homepage = "https://anttiharju.dev/relcheck/";
    description = "Performant relative link checker";
    changelog = "https://github.com/anttiharju/relcheck/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anttiharju ];
    mainProgram = "relcheck";
  };
}
