{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "minimal-grub-theme";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "tomdewildt";
    repo = "minimal-grub-theme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-otGWChSgoxRKfJZkw9usY1sxAc/RsXmkNVMxbSqtc04=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -r minimal/ $out/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimalistic GRUB theme insipired by primitivistical and vimix";
    homepage = "https://github.com/tomdewildt/minimal-grub-theme";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ azuwis ];
    platforms = lib.platforms.linux;
  };
})
