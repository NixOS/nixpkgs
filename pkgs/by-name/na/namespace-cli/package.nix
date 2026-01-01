{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "namespace-cli";
<<<<<<< HEAD
  version = "0.0.456";
=======
  version = "0.0.452";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-V+OHqM4rqoqroH3IL+zjhxmK4G5J04Fy6Yn/GqTqtaQ=";
  };

  vendorHash = "sha256-PwSDl4dPcTPGzXAunW4J4gyu9a68qTP3MpdexUpFt1U=";
=======
    hash = "sha256-hVxjejvpcacyOn0Lk1TKaPiwg+zpYfGwrrGWly1StGE=";
  };

  vendorHash = "sha256-rfaQR3B4YvEbI1sBZwwLcSJVrUL98UAmfUiLeK5bN/A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [
    "cmd/nsc"
    "cmd/ns"
    "cmd/docker-credential-nsc"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X namespacelabs.dev/foundation/internal/cli/version.Tag=v${version}"
  ];

  meta = {
    mainProgram = "nsc";
    maintainers = with lib.maintainers; [ techknowlogick ];
    license = lib.licenses.asl20;
    changelog = "https://github.com/namespacelabs/foundation/releases/tag/v${version}";
    homepage = "https://github.com/namespacelabs/foundation";
    description = "Command line interface for the Namespaces platform";
  };
}
