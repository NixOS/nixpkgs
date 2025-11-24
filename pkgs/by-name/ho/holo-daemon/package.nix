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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "holo-routing";
    repo = "holo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8cScq/6e9u3rDilnjT6mAbEudXybNj3YUicYiEgoCyE=";
  };

  passthru.updateScript = nix-update-script { };

  cargoHash = "sha256-YZ2c6W6CCqgyN+6i7Vh5fWLKw8L4pUqvq/tDO/Q/kf0=";

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
