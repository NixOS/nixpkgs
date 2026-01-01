{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "just-lsp";
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "terror";
    repo = "just-lsp";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-VA6rUcOc/O4KocefxGr4BFnGSb1Gv8+UObtHua/6lbg=";
  };

  cargoHash = "sha256-t+a24rBEHLgnrADRzMtrZHdeQ2tDxHK/bMzYidLPNQw=";
=======
    hash = "sha256-QwpChzZ+zC4MoVp6kNqbNF6+p4Rsd0KJfVuKPyxnnZU=";
  };

  cargoHash = "sha256-j/qLLyt9Sl1cXfNkKsyEYL/MQbxRMhni6uGmRVI+Xd8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Language server for just";
    homepage = "https://github.com/terror/just-lsp";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "just-lsp";
  };
})
