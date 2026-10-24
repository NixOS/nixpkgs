{
  lib,
  buildGo127Module,
  fetchFromGitHub,
}:

buildGo127Module (finalAttrs: {
  pname = "never-idle";
  version = "0.2.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "layou233";
    repo = "NeverIdle";
    rev = finalAttrs.version;
    hash = "sha256-wk4a2f2lkBKq8x49/TBicCctiZDXxDFXmcTDfPPIxws=";
  };

  vendorHash = "sha256-SLCo6ctAJglg0T0hBN63fJQZFuc0RcK2rDLJn0I5S3o=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv "$out/bin/neveridle" "$out/bin/NeverIdle"
  '';

  meta = {
    description = "Periodically waste CPU, memory and network resources to keep servers alive";
    homepage = "https://github.com/layou233/NeverIdle";
    license = lib.licenses.agpl3Only;
    mainProgram = "NeverIdle";
    maintainers = with lib.maintainers; [ yueyinqiu ];
  };
})
