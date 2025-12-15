{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-apk";
  version = "0.9.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-1vCrM+0SNefd7FrRXnSjLhM3/MSVJfcL4k1qAstX+/A=";
  };

  cargoHash = "sha256-8qjj5rcaqXBIte8+r0llj33Saat85SqNljGRaS1E3q0=";

  meta = {
    description = "Tool for creating Android packages";
    mainProgram = "cargo-apk";
    homepage = "https://github.com/rust-windowing/android-ndk-rs";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
