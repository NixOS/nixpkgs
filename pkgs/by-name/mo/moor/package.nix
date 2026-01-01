{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  pkgsCross,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "moor";
<<<<<<< HEAD
  version = "2.10.1";
=======
  version = "2.9.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "walles";
    repo = "moor";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-xnm1ZKceij5V2AgfB1ZAabDvB+l+Ha6F2WuHAzcA1mo=";
  };

  vendorHash = "sha256-MQPR4AW+Y+1l7akLxaWI5NAmKmhZdRKTzrueNEqHZoQ=";
=======
    hash = "sha256-+gNM/yqoEZ0JUieRsdGCpO5MG+Jtaxwi114PQEhaMiY=";
  };

  vendorHash = "sha256-KTAckjrOZVwl6UBFmbqqMjUyYJDQxySxWiV46QNTfuY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.versionString=v${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postInstall = ''
    installManPage ./moor.1
  '';

  passthru = {
    tests.cross-aarch64 = pkgsCross.aarch64-multiplatform.moor;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Nice-to-use pager for humans";
    homepage = "https://github.com/walles/moor";
    changelog = "https://github.com/walles/moor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2WithViews;
    mainProgram = "moor";
    maintainers = with lib.maintainers; [
<<<<<<< HEAD
      getchoo
      zowoq
=======
      foo-dogsquared
      getchoo
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
  };
})
