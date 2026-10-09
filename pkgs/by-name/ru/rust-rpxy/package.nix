{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cacert,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-rpxy";
  version = "0.14.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "junkurihara";
    repo = "rust-rpxy";
    tag = finalAttrs.version;
    hash = "sha256-yXcC5c0OfsJrn4zMubNNo9OxEH9Sg6MEhvPVRNgPlSM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cacert
  ];

  cargoHash = "sha256-sehnZSQnlb1yd8A7iE/D5kuGX45QeIB2jcndpIt2Nzg=";

  meta = {
    description = "Http reverse proxy serving multiple domain names and terminating TLS for http/1.1, 2 and 3, written in Rust";
    homepage = "https://github.com/junkurihara/rust-rpxy";
    changelog = "https://github.com/junkurihara/rust-rpxy/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      mit
    ];
    maintainers = with lib.maintainers; [
      kybe236
      jpteb
    ];
    mainProgram = "rpxy";
    platforms = lib.platforms.all;
  };
})
