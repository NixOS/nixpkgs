{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "pid1";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "fpco";
    repo = "pid1-rs";
    rev = "v${version}";
    hash = "sha256-BljIa+4BKI7WHlOhXfN/3VKMzs5G5E4tNlQ2oPpJV2g=";
  };

  cargoHash = "sha256-7PANlw/SKxyAqymfXIXFT/v3U0GCiGfgStguSr0lrqQ=";

  meta = with lib; {
    description = "Signal handling and zombie reaping for PID1 process";
    homepage = "https://github.com/fpco/pid1-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
    mainProgram = "pid1";
  };
}
