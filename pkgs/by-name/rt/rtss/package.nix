{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "rtss";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "Freaky";
    repo = "rtss";
    rev = "v${version}";
    sha256 = "sha256-WeeZsB42/4SlIaWwKvOqWiPNV5p0QOToynI8ozVVxJM=";
  };

  cargoHash = "sha256-7+58CMm9nPg9tVXphUcIufFGONOxjAlSWBseq5fbM44=";

  meta = with lib; {
    description = "Annotate output with relative durations between lines";
    mainProgram = "rtss";
    homepage = "https://github.com/Freaky/rtss";
    license = licenses.mit;
    maintainers = with maintainers; [ djanatyn ];
  };
}
