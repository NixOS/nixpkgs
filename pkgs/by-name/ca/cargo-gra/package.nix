{
  rustPlatform,
  fetchCrate,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-gra";
  version = "0.6.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-JbBcpp/E3WlQrwdxMsbSdmIEnDTQj/1XDwAWJsniRu0=";
  };

  cargoHash = "sha256-wfMiqWcEsL6/d6XFnEFm/lCbelU7BHC7JKdHREnynAU=";

  meta = {
    description = "gtk-rust-app cli for building flatpak apps with ease";
    homepage = "https://gitlab.com/floers/gtk-stuff/cargo-gra/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.unix;
  };
}
