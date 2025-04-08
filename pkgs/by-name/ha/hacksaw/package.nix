{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  libxcb,
  python3,
}:
let
  source = lib.importJSON ./source.json;
in
rustPlatform.buildRustPackage {
  inherit (source) pname version;

  src = fetchCrate source;
  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    libxcb
  ];

  postPatch = "cp ${./Cargo.lock} Cargo.lock";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Lightweight selection tool for usage in screenshot scripts etc";
    homepage = "https://github.com/neXromancers/hacksaw";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ acidbong ];
    platforms = lib.platforms.linux;
    mainProgram = "hacksaw";
  };
}
