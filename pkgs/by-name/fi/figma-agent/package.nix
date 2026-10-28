{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "figma-agent";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "neetly";
    repo = "figma-agent-linux";
    tag = finalAttrs.version;
    hash = "sha256-eP2C/u4CWdf7ABHdxapFcrmI1Un405wIHE0kpvz7y7A=";
  };

  cargoHash = "sha256-KmoTsriLnYvEI+yOOV9sLQ6qPRKqYRDzaYj7Kp72sP0=";

  meta = {
    description = "Figma Agent for Linux with a focus on performance";
    homepage = "https://github.com/neetly/figma-agent-linux";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "figma-agent";
    platforms = lib.platforms.linux;
  };
})
