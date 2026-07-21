{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rtss";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "Freaky";
    repo = "rtss";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-WeeZsB42/4SlIaWwKvOqWiPNV5p0QOToynI8ozVVxJM=";
  };

  cargoHash = "sha256-7+58CMm9nPg9tVXphUcIufFGONOxjAlSWBseq5fbM44=";

  meta = {
    description = "Annotate output with relative durations between lines";
    mainProgram = "rtss";
    homepage = "https://github.com/Freaky/rtss";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ djanatyn ];
  };
})
