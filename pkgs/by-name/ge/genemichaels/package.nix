{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "genemichaels";
  version = "0.8.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5cM5VyS5w92CjP3nVumuUNkCFlhipukRhM8ERhE36n4=";
  };

  cargoHash = "sha256-aJDtXsGVUxUrh3yLWEcobvFUqy/7PGFQHWIWU54zYdE=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Even formats macros";
    homepage = "https://github.com/andrewbaxter/genemichaels";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ djacu ];
    mainProgram = "genemichaels";
  };
}
