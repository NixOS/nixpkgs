{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "genemichaels";
  version = "0.9.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-KaGG2amPk/+fL7xLAfZw4SmCzXc+hS/9IkBG7G6sngI=";
  };

  cargoHash = "sha256-RkGKzE/EKA1VUkVTTMdMKhtUrs3kmy4uDAHq2hJs5yk=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Even formats macros";
    homepage = "https://github.com/andrewbaxter/genemichaels";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ djacu ];
    mainProgram = "genemichaels";
  };
}
