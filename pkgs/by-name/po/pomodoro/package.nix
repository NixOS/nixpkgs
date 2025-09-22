{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "pomodoro";
  version = "0-unstable-2021-06-18";

  src = fetchFromGitHub {
    owner = "SanderJSA";
    repo = "Pomodoro";
    rev = "c833b9551ed0b09e311cdb369cc8226c5b9cac6a";
    sha256 = "sha256-ZA1q1YVJcdSUF9NTikyT3vrRnqbsu5plzRI2gMu+qnQ=";
  };

  cargoHash = "sha256-oXOf9G0BMSbFFAsmRaAZzaquFva1i1gJ4ISqJkqSx4k=";

  meta = with lib; {
    description = "Simple CLI pomodoro timer using desktop notifications written in Rust";
    homepage = "https://github.com/SanderJSA/Pomodoro";
    license = licenses.mit;
    maintainers = with maintainers; [ annaaurora ];
    # error: redefinition of module 'ObjectiveC'
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "pomodoro";
  };
}
