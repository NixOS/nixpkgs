{
  lib,
  fetchFromGitHub,
  python3,
  rustPlatform,
  nix-update-script,
}:

let
  pname = "gluesql";
  version = "0.16.3";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "gluesql";
    repo = "gluesql";
    rev = "v${version}";
    hash = "sha256-3A/Lru03cO14aKIFS+fu6O8LxF1+tYK+7w97v1PbgyU=";
  };

  nativeBuildInputs = [
    python3
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-MVp3QMF9qXy0P72bOXsRbiV5+k497JjKLNRTjB75kww=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GlueSQL is quite sticky. It attaches to anywhere";
    homepage = "https://github.com/gluesql/gluesql";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.all;
  };
}
