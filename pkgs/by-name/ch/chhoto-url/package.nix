{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chhoto-url";
<<<<<<< HEAD
  version = "6.5.3";
=======
  version = "6.5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "SinTan1729";
    repo = "chhoto-url";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-y2bIRVlNOyz97RNfl1VkeR+4njclWM9Yo7NM/bI2J9k=";
=======
    hash = "sha256-gDD/1NKqPH84nr+EjTFfMGZkZfskQujn+uRGrnGs/fg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  sourceRoot = "${finalAttrs.src.name}/actix";

  postPatch = ''
    substituteInPlace src/{main.rs,services.rs} \
      --replace-fail "./resources/" "${placeholder "out"}/share/chhoto-url/resources/"
  '';

<<<<<<< HEAD
  cargoHash = "sha256-/NgHR5Fuby05iXut4hMKDqGVvvWF+NJFFxcRXlp606E=";
=======
  cargoHash = "sha256-jSdUKkZBgpMN05FmZUXHqBszuDAByf6bzIaaRNfymGY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  postInstall = ''
    mkdir -p $out/share/chhoto-url
    cp -r ${finalAttrs.src}/resources $out/share/chhoto-url/resources
  '';

  passthru = {
    tests = { inherit (nixosTests) chhoto-url; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple, blazingly fast, selfhosted URL shortener with no unnecessary features";
    homepage = "https://github.com/SinTan1729/chhoto-url";
    changelog = "https://github.com/SinTan1729/chhoto-url/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "chhoto-url";
  };
})
