{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitUpdater,
  makeWrapper,
  ripgrep,
}:
let
  pname = "serpl";
  version = "0.1.30";
in
rustPlatform.buildRustPackage {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "yassinebridi";
    repo = "serpl";
    rev = version;
    hash = "sha256-ZltOhlx9aPD5vO9eTpoXWR6qXUwB+jW+tATkwX9UlIU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  cargoHash = "sha256-FDS9JOmOtWOajB1tSd7QyW/KutRujs+3KjXxlNktrDM=";

  postFixup = ''
    # Serpl needs ripgrep to function properly.
    wrapProgram $out/bin/serpl \
      --prefix PATH : "${lib.strings.makeBinPath [ ripgrep ]}"
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Simple terminal UI for search and replace, ala VS Code";
    homepage = "https://github.com/yassinebridi/serpl.git";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NotAShelf ];
    mainProgram = "serpl";
  };
}
