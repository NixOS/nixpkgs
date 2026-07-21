{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "see-cat";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "guilhermeprokisch";
    repo = "see";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BmLMKTu9GHjO9/E31SBegC40qou7tvaX+dfG0GyXg/s=";
  };

  cargoHash = "sha256-Ct+NPJe7qMVC29s1dD0jDZN6iQElkf0kM3N9YH8Nh3Y=";

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
