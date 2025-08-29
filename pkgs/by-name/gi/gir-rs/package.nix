{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

let
  version = "0.19.0";
in
rustPlatform.buildRustPackage {
  pname = "gir";
  inherit version;

  src = fetchFromGitHub {
    owner = "gtk-rs";
    repo = "gir";
    rev = version;
    sha256 = "sha256-GAAK4ej16e5/sjnPOVWs4ul1H9sqa+tDE8ky9tbB9No=";
  };

  cargoHash = "sha256-ObEXOaEdwJpaLJDkcSmAK86P7E6y0eUQQHFpX4hsuog=";

  postPatch = ''
    rm build.rs
    sed -i '/build = "build\.rs"/d' Cargo.toml
    echo "pub const VERSION: &str = \"$version\";" > src/gir_version.rs
  '';

  meta = with lib; {
    description = "Tool to generate rust bindings and user API for glib-based libraries";
    homepage = "https://github.com/gtk-rs/gir/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ekleog ];
    mainProgram = "gir";
  };
}
