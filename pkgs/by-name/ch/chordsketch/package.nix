{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "chordsketch";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "koedame";
    repo = "chordsketch";
    tag = "v${version}";
    hash = "sha256-8i5rDUVmE5MKqXtXY8bgumEHr8jVS6bk9XClZATwC6E=";
  };

  cargoHash = "sha256-52vnW3E7Fdl2aLOKh+w13Tmf0PaD6FdXqf+YyCV6Yec=";

  cargoBuildFlags = [ "--package" "chordsketch" ];
  cargoTestFlags = [ "--package" "chordsketch" ];

  meta = {
    description = "ChordPro file format renderer and CLI (text, HTML, PDF)";
    homepage = "https://github.com/koedame/chordsketch";
    changelog = "https://github.com/koedame/chordsketch/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "chordsketch";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
