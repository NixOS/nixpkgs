{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "humanshell";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "juanparati";
    repo = "humanshell";
    rev = "v${version}";
    sha256 = "sha256-u2aCZVfh5ag6/AN6x9ewVxl21f9UwJ6rudtwK9VRQ4c=";
  };

  cargoHash = "sha256-4oyP8oXscmbiZRAK22RwZ5k6vgrCSWAq58SVf3m9zzg=";

  meta = with lib; {
    description = "Translate human expressions into shell expressions";
    homepage = "https://github.com/juanparati/humanshell";
    license = with licenses; [
      mit
    ];
    maintainers = [ maintainers.juanparati ];
    platforms = platforms.unix;
    longDescription = ''
      A command-line tool that translates human expressions into shell commands
      using the Anthropic API and Open AI API.
    '';
    mainProgram = "hs";
  };
}
