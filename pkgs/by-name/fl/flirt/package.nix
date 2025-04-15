{
  rustPlatform,
  fetchFromSourcehut,
  lib,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "flirt";
  version = "0.3";

  src = fetchFromSourcehut {
    owner = "~hadronized";
    repo = "flirt";
    rev = "v${version}";
    hash = "sha256-xhNo85xwcVI4qliHU4/uNEvS7rW5avKOv8fMfRrvqD0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Nu4sOjwF/MlsoCmgUEGEqMIW+aSD9PuiFBQMnfQRL8Q=";

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
