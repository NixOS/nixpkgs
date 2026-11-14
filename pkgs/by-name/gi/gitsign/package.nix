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
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = "gitsign";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CglJBB8YaeWtqCmKPTHg4YozJJGiff3LpsE+6ua+5vU=";
  };
  vendorHash = "sha256-PImOVmwPDSkAtJYus5i1lXsP+wt1TLDmSSgCm9M7/ks=";

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
