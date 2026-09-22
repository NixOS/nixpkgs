{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "legitify";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "Legit-Labs";
    repo = "legitify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ijW0vvamuqcN6coV5pAtmjAUjzNXxiqr2S9EwrNlrJc=";
  };

  vendorHash = "sha256-XPfqQFGJ5yZJVFzHq4zzTXzwuxsAPJvTrZBK+gZWRKE=";

  overrideModAttrs = oldAttrs: {
    postPatch = (oldAttrs.postPatch or "") + ''
      export GOCACHE=$TMPDIR/go-cache
      export GOPATH=$TMPDIR/go
      go mod edit -replace golang.org/x/tools=golang.org/x/tools@v0.30.0
      go mod tidy
    '';
    postBuild = (oldAttrs.postBuild or "") + ''
      cp go.mod go.sum vendor/
    '';
  };

  preBuild = ''
    if [ -d vendor ]; then
      chmod -R u+w vendor
      cp vendor/go.mod vendor/go.sum .
    fi
  '';

  ldflags = [
    "-w"
    "-s"
    "-X=github.com/Legit-Labs/legitify/internal/version.Version=${finalAttrs.version}"
  ];

  preCheck = ''
    rm e2e/e2e_test.go # tests requires network
  '';

  meta = {
    description = "Tool to detect and remediate misconfigurations and security risks of GitHub assets";
    homepage = "https://github.com/Legit-Labs/legitify";
    changelog = "https://github.com/Legit-Labs/legitify/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "legitify";
  };
})
