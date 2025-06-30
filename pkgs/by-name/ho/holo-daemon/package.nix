{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  protobuf,
  pcre2,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "holo-daemon";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "holo-routing";
    repo = "holo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wASY+binAflxaXjKdSfUXS8jgdEHjdIF3AOzjN/a1Fo=";
  };

  passthru.updateScript = nix-update-script { };

  cargoHash = "sha256-5X6a86V3Y9+KK0kGbS/ovelqXyLv15gQRFI7GhiYBjY=";

  # Use rust nightly features
  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
  ];
  buildInputs = [
    pcre2
  ];

  # Might not be needed if latest nightly compiler version is used
  preConfigure = ''
    # Find all lib.rs and main.rs files and add required unstable features
    # Add the feature flag at the top of the file if not present`
    find . -name "lib.rs" -o -name "main.rs" | while read -r file; do
      for feature in extract_if let_chains hash_extract_if; do
        if ! grep -q "feature.*$feature" "$file"; then
          sed -i "1i #![feature($feature)]" "$file"
        fi
      done
    done
  '';

  meta = {
    description = "`holo` daemon that provides the routing protocols, tools and policies";
    homepage = "https://github.com/holo-routing/holo";
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ themadbit ];
    license = lib.licenses.mit;
    mainProgram = "holod";
    platforms = lib.platforms.linux;
  };
})
