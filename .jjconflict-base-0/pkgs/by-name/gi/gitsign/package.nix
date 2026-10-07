{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  gitMinimal,
  testers,
  gitsign,
}:

buildGoModule (finalAttrs: {
  pname = "gitsign";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = "gitsign";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cXgCgHL1zy4LBYuUxJUO8unkbG1lrxC31i790+6DVv0=";
  };
  vendorHash = "sha256-SitjW9g+GY1YDmJP13eTGL2Om2EsV+HRrXbLb6g+w3Y=";

  subPackages = [
    "."
    "cmd/gitsign-credential-cache"
  ];

  nativeBuildInputs = [ makeWrapper ];
  nativeCheckInputs = [ gitMinimal ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/sigstore/gitsign/pkg/version.gitVersion=${finalAttrs.version}"
  ];

  preCheck = ''
    # test all paths
    unset subPackages
  '';

  postInstall = ''
    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
    done
  '';

  passthru.tests.version = testers.testVersion { package = gitsign; };

  meta = {
    homepage = "https://github.com/sigstore/gitsign";
    changelog = "https://github.com/sigstore/gitsign/releases/tag/v${finalAttrs.version}";
    description = "Keyless Git signing using Sigstore";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      lesuisse
      developer-guy
    ];
    mainProgram = "gitsign";
  };
})
