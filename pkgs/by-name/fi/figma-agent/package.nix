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
    rev = "main";
    sha256 = "sha256-Cq+ivyrj6wt7DEUM730BG44sMkpOMt4qxb+J3itVar4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QdEs1zaQ2CQT50nIhKxtp7zpJfa64xQgOy3sTOUGmxk=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    fontconfig
    freetype
  ];

  # No tests on `figma-agent-linux`.
  doCheck = false;

  meta = {
    homepage = "https://github.com/neetly/figma-agent-linux";
    description = "Figma Agent for Linux (a.k.a. Font Helper)";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ercao ];
    mainProgram = "figma-agent";
  };
}
