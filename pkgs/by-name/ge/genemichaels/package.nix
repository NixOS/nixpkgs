{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "genemichaels";
  version = "0.5.13";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ZJr5cN+Bam71fPDwhcYUVop5JW8145tzY7Sk75fjhvQ=";
  };

  cargoHash = "sha256-SVJ3vXa2yNhdayUsYNpXSqLrMzi4JzjKuh0VTteIOLs=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Even formats macros";
    homepage = "https://github.com/andrewbaxter/genemichaels";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ djacu ];
    mainProgram = "genemichaels";
  };
}
