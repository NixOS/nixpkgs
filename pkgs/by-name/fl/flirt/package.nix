{
  rustPlatform,
  fetchFromSourcehut,
  lib,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "flirt";
<<<<<<< HEAD
  version = "0.4.1";
=======
  version = "0.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromSourcehut {
    owner = "~hadronized";
    repo = "flirt";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-L7BiNA/cG7e1GX9sOxwwLS5+2/Tpb1PeA/2rPz8ALf8=";
  };

  cargoHash = "sha256-roPPL9zR8JBr3Ya2IhkvIOfnKxuRSXdxxaJ80ZUK87M=";
=======
    hash = "sha256-wH6WLLUqUj5YrrudNbGkzZ4i15xRPDBE3UKwyhkQSxg=";
  };

  cargoHash = "sha256-m1aLJFa6C5X9HwNweezoUcFnpG09AuYf9ooet8GUGFE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "FiLe InteRacT, the file interaction tool for your command line";
    homepage = "https://git.sr.ht/~hadronized/flirt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      adda
    ];
    mainProgram = "flirt";
  };
}
