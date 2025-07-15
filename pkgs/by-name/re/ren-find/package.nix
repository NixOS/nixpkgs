{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "ren-find";
  version = "0-unstable-2024-01-11";

  src = fetchFromGitHub {
    owner = "robenkleene";
    repo = "ren-find";
    rev = "50c40172e354caffee48932266edd7c7a76a20f";
    hash = "sha256-zVIt6Xp+Mvym6gySvHIZJt1QgzKVP/wbTGTubWk6kzI=";
  };

  cargoHash = "sha256-lSeO/GaJPZ8zosOIJRXVIEuPXaBg1GBvKBIuXtu1xZg=";

  meta = with lib; {
    description = "Command-line utility that takes find-formatted lines and batch renames them";
    homepage = "https://github.com/robenkleene/ren-find";
    license = licenses.mit;
    maintainers = with maintainers; [ philiptaron ];
    mainProgram = "ren";
  };
}
