{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-gg";
  version = "0.1.1";

  src = fetchCrate {
    inherit version;
    pname = "cargo-gg";
    hash = "sha256-O8RwD3M7MGLyTIRqWRfKoDmaaT+ylxM4e4PcayyrA+c=";
  };

  cargoHash = "sha256-WVjM7z6blk4CBO3FpzXfiiopu/lsTnzt2XnreLizMKM=";

  meta = with lib; {
    description = "Cargo wrapper that calls you a good girl if your commands succeed (but only after they fail)";
    mainProgram = "cargo-gg";
    homepage = "https://gitlab.scd31.com/stephen/cargo-gg";
    license = with licenses; [
      mit
    ];
    maintainers = with maintainers; [ scd31 ];
  };
}
