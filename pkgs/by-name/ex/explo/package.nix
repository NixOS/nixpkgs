{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "explo";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "LumePart";
    repo = "Explo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uBJe6bSStVIoKw9Aa/vtojlMOxo7c7RzfJTlZyRdvEk=";
  };

  vendorHash = "sha256-Npi6rwopOADlbbi0RdalfRtiH2tdgXWWrIhYcYKSRZg=";

  postInstall = ''
    mv $out/bin/main $out/bin/explo
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Spotify's \"Discover Weekly\" for self-hosted music systems";
    homepage = "https://github.com/LumePart/Explo/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lilacious ];
    mainProgram = "explo";
  };
})
