{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  fontconfig,
  freetype,
}:
rustPlatform.buildRustPackage {
  pname = "figma-agent";
  version = "0.3.2-unstable-2024-11-16";

  src = fetchFromGitHub {
    owner = "neetly";
    repo = "figma-agent-linux";
    rev = "6709a1b7ffcbfb227472d8f017bfbbda77ddca7d";
    sha256 = "sha256-Cq+ivyrj6wt7DEUM730BG44sMkpOMt4qxb+J3itVar4=";
  };

  cargoHash = "sha256-QdEs1zaQ2CQT50nIhKxtp7zpJfa64xQgOy3sTOUGmxk=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    fontconfig
    freetype
  ];

  checkFlags = [
    # All tests fail due to unavailable bindings
    "--skip=figma-agent-freetype-sys"
  ];

  meta = {
    description = "Figma Agent for Linux with a focus on performance";
    homepage = "https://github.com/neetly/figma-agent-linux";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "figma-agent";
    platforms = lib.platforms.linux;
  };
}
