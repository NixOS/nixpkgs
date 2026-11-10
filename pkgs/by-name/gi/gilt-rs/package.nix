{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gilt-rs";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "simonhollingshead";
    repo = "gilt-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ulDP/av+WrAiJWs+DJWz3dEtSVeZBAEsJZ4Up0DbYmE=";
  };

  cargoHash = "sha256-jV4yeYnZW0qnw82PBChwarGxCpk7JzeH4ovPHFdBV7k=";

  __structuredAttrs = true;

  meta = {
    description = "Tool for calculating which UK Gilt will give the best return if held to maturity";
    homepage = "https://github.com/simonhollingshead/gilt-rs";
    license = lib.licenses.mit;
    mainProgram = "gilt";
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
