{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pandoc-katex";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "xu-cheng";
    repo = "pandoc-katex";
    rev = finalAttrs.version;
    hash = "sha256-2a3WJTNIMqWnTlHB+2U/6ifuoecbOlTP6e7YjD/UvPM=";
  };

  cargoHash = "sha256-Ve8s+LLjJiP/I+A/X23CnGiRsbfz5sxFr6kySAgYTyE=";

  meta = {
    description = "Pandoc filter to render math equations using KaTeX";
    homepage = "https://github.com/xu-cheng/pandoc-katex";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      minijackson
      euxane
    ];
    mainProgram = "pandoc-katex";
  };
})
