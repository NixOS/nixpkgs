{
  lib,
  rustPlatform,
  fetchFromGitHub,
<<<<<<< HEAD
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lix-diff";
  version = "1.1.1";
=======
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lix-diff";
  version = "1.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "lix-diff";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-uZd8xoQWsvJCmHtxtKJzKtaupUdXMXKWqSjXnK/BZco=";
  };

  cargoHash = "sha256-ydB65V879tW42FXSgdoUDeQbovsVf8qXku9uW4mqAfs=";

  passthru.updateScript = nix-update-script { };
=======
    hash = "sha256-apjYXFdvxLZjhcN1wV7Y/LKNuWtWtCZM0h1VFg/znVo=";
  };

  cargoHash = "sha256-u3aFmPcceLP7yPdWWoPmOnQEbM0jhULs/kPweymQcZ8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    homepage = "https://github.com/isabelroses/lix-diff";
    description = "Lix plugin for diffing two generations";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "lix-diff";
  };
})
