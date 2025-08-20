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
    repo = pname;
    rev = version;
    hash = "sha256-2a3WJTNIMqWnTlHB+2U/6ifuoecbOlTP6e7YjD/UvPM=";
  };

  cargoHash = "sha256-Qf+QYOIBmSgax7p5K32SkaDT0MoKUY4TkxLbf/ZbM+U=";

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
