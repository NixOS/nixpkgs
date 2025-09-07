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
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "alemidev";
    repo = "scope-tui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bVe+Yyv+DcbEC15H968OhQhcFkAm7T5J6aQlKod5ocM=";
  };

  cargoHash = "sha256-o5pplwNtIe2z88ZwtCHree32kv16U/ryv8PmPIqxtPQ=";

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
