{
  lib,
  buildGoModule,
  fetchFromGitLab,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "sigsum";
<<<<<<< HEAD
  version = "0.13.1";
=======
  version = "0.12.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    domain = "git.glasklar.is";
    group = "sigsum";
    owner = "core";
    repo = "sigsum-go";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-GQ8ENsMc9vrAG23wHDPcWVadRVov3XOgR5WxnXtg94A=";
=======
    hash = "sha256-SFEKbPOAU2cpsc9oLiX3Lhv/AvYNPNiLjjjGteHOtpg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace internal/version/version.go \
      --replace-fail "info.Main.Version" '"${finalAttrs.version}"'
  '';

<<<<<<< HEAD
  vendorHash = "sha256-SWNvBEIV25G9lp95DsftFKa48iGUgBQ4RdplJ5D1xUg=";
=======
  vendorHash = "sha256-2v9NShhmHr0O5FH49tDSPUK1lT2tmhJkrZaVTwrL3cY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
  ];

  excludedPackages = [ "./test" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/sigsum-key";
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "System for public and transparent logging of signed checksums";
    homepage = "https://www.sigsum.org/";
    downloadPage = "https://git.glasklar.is/sigsum/core/sigsum-go";
    changelog = "https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/v${finalAttrs.version}/NEWS";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ defelo ];
  };
})
