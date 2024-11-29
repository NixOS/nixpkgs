{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libpulseaudio,
  alsa-lib,
  withPulseaudio ? true,
}:
rustPlatform.buildRustPackage {
  pname = "scope-tui";
  version = "0.3.0-unstable-2024-05-06";

  src = fetchFromGitHub {
    owner = "alemidev";
    repo = "scope-tui";
    rev = "c2fe70a69cfc15c4de6ea3f2a51580ec57a5c9e1";
    hash = "sha256-6UPIZ2UB5wb0IkigaOXdQ/0ux9vHUGC4w5WnrjEd1bg=";
  };

  cargoHash = "sha256-9e5FOf7X+54591SjikeAq/5gsnqjUOEtVKpr6vWAHMI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ alsa-lib ] ++ lib.optionals withPulseaudio [ libpulseaudio ];

  buildFeatures = lib.optionals withPulseaudio [ "pulseaudio" ];

  doCheck = false; # no tests

  meta = {
    description = "Simple oscilloscope/vectorscope/spectroscope for your terminal";
    homepage = "https://github.com/alemidev/scope-tui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      iynaix
      aleksana
    ];
    mainProgram = "scope-tui";
    platforms = lib.platforms.linux;
  };
}
