{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "avalanchego";
<<<<<<< HEAD
  version = "1.14.0";
=======
  version = "1.13.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = "avalanchego";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-jMMnhzrNoorU/GtDKXFnS7bbEc052qAMkFgWWwzlBwg=";
=======
    hash = "sha256-XGRGjoZyhvcQFhfZIYdljT77SUxrWhD46F6ckxD602Q=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # https://github.com/golang/go/issues/57529
  proxyVendor = true;

<<<<<<< HEAD
  vendorHash = "sha256-CnbXcDOXk/RuGqtIGdWqsJBaQdIIzTLz2hmxR29Gt0Y=";
=======
  vendorHash = "sha256-mff3Hlkp6gfq8HS7ypz9QikbDo98SwHF3g3Bq3i9RMY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "main" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ava-labs/avalanchego/version.GitCommit=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/{main,avalanchego}
  '';

<<<<<<< HEAD
  passthru.updateScript = nix-update-script {
    # Needed to avoid pre-releases
    extraArgs = [ "--use-github-releases" ];
  };
=======
  passthru.updateScript = nix-update-script { };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Go implementation of an Avalanche node";
    homepage = "https://github.com/ava-labs/avalanchego";
    changelog = "https://github.com/ava-labs/avalanchego/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      urandom
      qjoly
    ];
    mainProgram = "avalanchego";
  };
})
