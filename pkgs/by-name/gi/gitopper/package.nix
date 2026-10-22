{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "gitopper";
  version = "0.0.20";

  src = fetchFromGitHub {
    owner = "miekg";
    repo = "gitopper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-y0gzoXSIQDQ6TMVsAijPaN0sRqFEtTKyd297YxXAukM=";
  };

  ldflags = [ "-X main.Version=${finalAttrs.version}" ];

  vendorHash = "sha256-b9lLOGk0h0kaWuZb142V8ojfpstRhzC9q2kSu0q7r7I=";

  nativeCheckInputs = [
    makeWrapper
    git
  ];

  checkFlags =
    let
      # Skip tests that does not works well inside an isolated environment
      skippedTests = [
        "TestInitialGitCheckout"
        "TestHash"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    wrapProgram $out/bin/gitopper \
      --suffix PATH : ${lib.makeBinPath [ git ]}
  '';

  meta = {
    description = "Gitops for non-Kubernetes folks";
    homepage = "https://github.com/miekg/gitopper/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "gitopper";
  };
})
