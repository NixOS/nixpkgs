{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "markdown-oxide";
<<<<<<< HEAD
  version = "0.25.10";
=======
  version = "0.25.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Feel-ix-343";
    repo = "markdown-oxide";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-nzUje11rp6ByfajrxeEszi1mYs2Pu9Fq+blRdUECqT4=";
  };

  cargoHash = "sha256-Zzo7lEGfzPpxODeVHm89q22aAmuN5h2nIdh2eF2jSpY=";
=======
    hash = "sha256-Y3xMiWnLHDVeRn1KbmsC/5yJWhukKFB6X9VHnuEkFU8=";
  };

  cargoHash = "sha256-M4LwkF031bv7aIC9aEh5bF6Vk/DJt3DH1Rh3dUNopX4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Markdown LSP server inspired by Obsidian";
    homepage = "https://github.com/Feel-ix-343/markdown-oxide";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      linsui
      jukremer
      HeitorAugustoLN
    ];
    mainProgram = "markdown-oxide";
  };
})
