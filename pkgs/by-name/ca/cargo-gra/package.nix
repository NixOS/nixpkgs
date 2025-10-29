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

  cargoHash = "sha256-B32GCIlFngfubwZqxMneAO24hhJ1zOgW6gXMHzgr89A=";

  meta = {
    description = "CLI for building flatpak apps with ease";
    homepage = "https://gitlab.com/floers/gtk-stuff/cargo-gra/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.unix;
  };
}
