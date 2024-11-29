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

  nativeBuildInputs = [ makeWrapper ];

  cargoHash = "sha256-8XYEZQfoizVmOuh0hymzMj2UDiXNkSeHqBAWOqaMY84=";

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
