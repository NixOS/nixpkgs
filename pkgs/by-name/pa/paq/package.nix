{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "paq";
<<<<<<< HEAD
  version = "1.4.1";
=======
  version = "1.3.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "gregl83";
    repo = "paq";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-L9hjTdpV7j1qKX9GSo9Nb+nA1mPKz2aftAquiBuUbn4=";
  };

  cargoHash = "sha256-LjAPCdPZI/qGISb4/kY2fRG0G0d/VwHeISAmfZSF4sI=";

  nativeInstallCheckInputs = [ versionCheckHook ];
=======
    hash = "sha256-2HlQzb3foNv/F35u7/737eJfNTsiQRCymggKAQ+mIS0=";
  };

  cargoHash = "sha256-LlqKdJhmOYnmnZA+xh7sogcnMWgpgm5qV6vwM3n3vng=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hash file or directory recursively";
    homepage = "https://github.com/gregl83/paq";
    changelog = "https://github.com/gregl83/paq/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lafrenierejm ];
    mainProgram = "paq";
  };
})
