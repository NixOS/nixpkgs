{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  zstd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "figma-agent";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "neetly";
    repo = "figma-agent-linux";
    tag = finalAttrs.version;
    hash = "sha256-E9Pn00wjvzAEubAfVx4Q9oBaUFtL6TLAVhRGONDq4LA=";
  };

  cargoHash = "sha256-OKDrATg8FSQZdyJNo2ns8gpfCv9/3eqZy+muPbkvJ8g=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ];

  meta = {
    description = "Figma Agent for Linux with a focus on performance";
    homepage = "https://github.com/neetly/figma-agent-linux";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "figma-agent";
    platforms = lib.platforms.linux;
  };
})
