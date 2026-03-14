{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "see-cat";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "guilhermeprokisch";
    repo = "see";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ej8lk9btUcIhhgpSmnHo2n33wQtyEkmuWVFoahYgAaI=";
  };

  cargoHash = "sha256-gADA6Ioxz8YM/SRYsT+43bKNS2Ov1XtTElDr7vx8T14=";

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
})
