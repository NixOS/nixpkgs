{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "pandoc-katex";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "xu-cheng";
    repo = "pandoc-katex";
    rev = version;
    hash = "sha256-2a3WJTNIMqWnTlHB+2U/6ifuoecbOlTP6e7YjD/UvPM=";
  };

  cargoHash = "sha256-Ve8s+LLjJiP/I+A/X23CnGiRsbfz5sxFr6kySAgYTyE=";

  meta = with lib; {
    description = "Pandoc filter to render math equations using KaTeX";
    homepage = "https://github.com/xu-cheng/pandoc-katex";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      minijackson
      euxane
    ];
    mainProgram = "pandoc-katex";
  };
}
