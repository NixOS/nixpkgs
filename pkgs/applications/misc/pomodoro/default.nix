{ lib, stdenv, fetchFromGitHub, rustPlatform, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "pomodoro";
  version = "unstable-2021-06-18";

  src = fetchFromGitHub {
    owner = "SanderJSA";
    repo = "Pomodoro";
    rev = "c833b9551ed0b09e311cdb369cc8226c5b9cac6a";
    sha256 = "sha256-ZA1q1YVJcdSUF9NTikyT3vrRnqbsu5plzRI2gMu+qnQ=";
  };

  cargoSha256 = "sha256-6ZhWStZebXSwrej36DXifrsrmR1SWW3PwGUX0hqPwE4=";
  buildInputs = lib.optionals stdenv.isDarwin [ Foundation ];

  meta = with lib; {
    description = "Simple CLI pomodoro timer using desktop notifications written in Rust";
    homepage = "https://github.com/SanderJSA/Pomodoro";
    license = licenses.mit;
    maintainers = with maintainers; [ annaaurora ];
    # error: redefinition of module 'ObjectiveC'
    broken = stdenv.isDarwin;
    mainProgram = "pomodoro";
  };
}
