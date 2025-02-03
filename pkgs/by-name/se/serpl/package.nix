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
  version = "0.1.34";
in
rustPlatform.buildRustPackage {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "yassinebridi";
    repo = "serpl";
    rev = version;
    hash = "sha256-U6fcpFe95rM3GXu7OJhhGkpV1yQNUukqRpGeOtd8UhU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  cargoHash = "sha256-YAp7r7I/LX/4T93auGusTLPKpuZd3XzZ4HP6gOR0DZ0=";

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
