{
  rustPlatform,
  fetchCrate,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-gra";
  version = "0.6.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-cli7qaIVYvoZpDml/QAxm2vjvh/g28zlDSpU9IIUBfw=";
  };

  cargoHash = "sha256-xsaavcpDaiDDbL3Dl+7NLcfB5U6vuYsVPoIuA/KXCvI=";

  meta = {
    license = lib.licenses.gpl3Plus;
    homepage = "https://gitlab.com/floers/gtk-stuff/cargo-gra/";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.unix;
    description = "gtk-rust-app cli for building flatpak apps with ease";
  };
}
