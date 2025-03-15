{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitUpdater,
  makeWrapper,
  ast-grep,
  ripgrep,
}:
let
  pname = "serpl";
  version = "0.3.3";
in
rustPlatform.buildRustPackage {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "yassinebridi";
    repo = "serpl";
    rev = version;
    hash = "sha256-koD5aFqL+XVxc5Iq3reTYIHiPm0z7hAQ4K59IfbY4Hg=";
  };

  buildFeatures = [ "ast_grep" ];

  nativeBuildInputs = [ makeWrapper ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-YfSxjlpUyRwpSoKmHOZrULGIIWTQ14JJwbsNB807WYQ=";

  postFixup = ''
    # Serpl needs ripgrep to function properly.
    wrapProgram $out/bin/serpl \
      --prefix PATH : "${
        lib.strings.makeBinPath [
          ripgrep
          ast-grep
        ]
      }"
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
