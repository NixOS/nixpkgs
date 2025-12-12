{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "genemichaels";
  version = "0.9.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-jkEbIDbstAI2rLXe6G9171bIKG76vVyb8ycRKhhwP0A=";
  };

  cargoHash = "sha256-2dhAKZ8dTcaGk+IE+FR8J2eOKh37jd8BoM4wKMvvOmE=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Even formats macros";
    homepage = "https://github.com/andrewbaxter/genemichaels";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ djacu ];
    mainProgram = "genemichaels";
  };
}
