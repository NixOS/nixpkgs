{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gotip";
<<<<<<< HEAD
  version = "0.6.2";
=======
  version = "0.5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "gotip";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-i5DgBuRHGLuR99lAv8M8eycd8MtEUtgGjKrI4YMoGIo=";
  };

  vendorHash = "sha256-+saAOzbBpmd7+s7FXUUB30tmi53RpDRckeLiT36ykE4=";
=======
    hash = "sha256-z5Xk+lTDAvkMOJAR6eIC6rg+CP9wv+CSANdgj+KmPjA=";
  };

  vendorHash = "sha256-AgyFhoyPyXN5ngTi8iKzbx0wOqlu64gFdrygPOFHZT4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go test interactive picker";
    homepage = "https://github.com/lusingander/gotip";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "gotip";
  };
})
