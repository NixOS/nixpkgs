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
  version = "0.1.26";
in
rustPlatform.buildRustPackage {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "yassinebridi";
    repo = "serpl";
    rev = version;
    hash = "sha256-ppF74VI0ceB4G/RLTa1phEy+tQ34r4hOMxqlK7YeLo0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  cargoHash = "sha256-/TnuRRzeCPp8pqa/soGV0b3ZYp0cCbt3un6SjatSGp0=";

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
