{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "minimal-grub-theme";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "tomdewildt";
    repo = "minimal-grub-theme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CegLznlW+UJZbVe+WG/S8tREFdw0aq3flGvJeDrLWK0=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/

    cp -r minimal/icons minimal/theme.txt minimal/*.png $out/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Minimalistic GRUB theme insipired by primitivistical and vimix";
    homepage = "https://github.com/tomdewildt/minimal-grub-theme";
    license = licenses.mit;
    maintainers = with maintainers; [ azuwis ];
    platforms = platforms.linux;
  };
})
