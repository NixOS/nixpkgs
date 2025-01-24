{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "see-cat";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "guilhermeprokisch";
    repo = "see";
    rev = "v${version}";
    hash = "sha256-VCUrPCaG2fKp9vpFLzNLcfCBu2NiwdY2+bo1pd7anZY=";
  };

  cargoHash = "sha256-lfpJ40QpZ9eQhDFJjLwiDU5DmaYAqCh5iJSjZ+jj+kk=";

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "Cute cat(1) for the terminal";
    longDescription = ''
      see is a powerful file visualization tool for the terminal, offering
      advanced code viewing capabilities, Markdown rendering, and
      more. It provides syntax highlighting, emoji support, and image
      rendering capabilities, offering a visually appealing way to view
      various file types directly in your console.
    '';
    homepage = "https://github.com/guilhermeprokisch/see";
    license = lib.licenses.mit;
    mainProgram = "see";
    maintainers = with lib.maintainers; [ louis-thevenet ];
  };
}
