{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "omdd";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "amirrezaDev1378";
    repo = "ollama-model-direct-download";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kEDI22af9+xSpwWouuR+KA/vofbOj5E0BDubjzRbwh0=";
  };

  vendorHash = null;

  doCheck = false;

  postInstall = ''
    mv $out/bin/cmd $out/bin/omdd
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/amirrezaDev1378/ollama-model-direct-download/releases/tag/v${finalAttrs.version}";
    description = " Ollama model direct link generator and installer";
    homepage = "https://github.com/amirrezaDev1378/ollama-model-direct-download";
    license = with lib.licenses; [ mit ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ners ];
    mainProgram = "omdd";
  };
})
