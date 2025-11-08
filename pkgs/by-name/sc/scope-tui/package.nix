{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libpulseaudio,
  alsa-lib,
  withPulseaudio ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "scope-tui";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "alemidev";
    repo = "scope-tui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MU9avQt+qFIQzF7GYNNoGiyfBD7eLOMQaBH6lFhLlOY=";
  };

  cargoHash = "sha256-yAy3kk62HYe1/1EXGUhOg++sZua65iN3ZEmPoERcu0I=";

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
})
