{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "minimal-grub-theme";
<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "tomdewildt";
    repo = "minimal-grub-theme";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-otGWChSgoxRKfJZkw9usY1sxAc/RsXmkNVMxbSqtc04=";
=======
    hash = "sha256-CegLznlW+UJZbVe+WG/S8tREFdw0aq3flGvJeDrLWK0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

<<<<<<< HEAD
    cp -r minimal/ $out/
=======
    mkdir -p $out/

    cp -r minimal/icons minimal/theme.txt minimal/*.png $out/
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
