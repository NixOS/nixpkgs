{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "see-cat";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "guilhermeprokisch";
    repo = "see";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3uyQW1PxLYxpissm96io5IrZ6uU4S4MdcS+O56CftxA=";
  };

  cargoHash = "sha256-Sba5l5Jx/F+Iux3TYT3gMWBkN9yyVQ1n3MZCNl7q0u8=";

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
