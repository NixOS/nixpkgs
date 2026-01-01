{
  buildGoModule,
  lib,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
  darwin,
}:

buildGoModule rec {
  pname = "slackdump";
<<<<<<< HEAD
  version = "3.1.11";
=======
  version = "3.1.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "rusq";
    repo = "slackdump";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-p9d7BGWNssOwYERwWs8jer/um+wMLkMwvQcOg1pJ2eg=";
=======
    hash = "sha256-sbin16iMz5ePXWE8KdpdbY+VaqgnpGH4xyyD2pq1kbo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeCheckInputs = lib.optional stdenv.hostPlatform.isDarwin darwin.IOKitTools;

  checkFlags =
    let
      skippedTests = [
        "TestSession_saveUserCache"
        "TestSession_GetUsers"
        "Test_exportV3" # This was skipped on upstream's CI. It is seemed that some file are missed
      ];
    in
    [
      "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$"
    ];

<<<<<<< HEAD
  vendorHash = "sha256-ny+cIpmMqRbrMT65GCpVRTWlxVEcKS6D+roO+Qbq47U=";
=======
  vendorHash = "sha256-7ySux+c4cun8dm7JhJpjSsFekru6emV6GCta3KL6m34=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/rusq/slackdump";
    changelog = "https://github.com/rusq/slackdump/releases/tag/v${version}";
    description = "Tools for saving Slack's data without admin privileges";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "slackdump";
    license = lib.licenses.gpl3Plus;
  };
}
