{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "bento";
<<<<<<< HEAD
  version = "1.13.1";
=======
  version = "1.12.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "warpstreamlabs";
    repo = "bento";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-5UzicbR+JzLgPLilPHO9HKteC632cJc5EQanPPc0lj8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-wZPhjzDD2T7CYz0Y0QkFarnTOsJzm5snlp9KnBuOc3U=";
=======
    hash = "sha256-KW/qq2hntXcG26atA1yRJUzSMns0e1n2U5nascU1Ci8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-YPCC8xK4lRtRzNjx6U8O7/+PqhhOaM/QofnOvH1rg9Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [
    "cmd/bento"
    "cmd/serverless/bento-lambda"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/warpstreamlabs/bento/internal/cli.Version=${version}"
    "-X main.Version=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High performance and resilient stream processor";
    homepage = "https://warpstreamlabs.github.io/bento/";
    changelog = "https://github.com/warpstreamlabs/bento/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "bento";
  };
}
