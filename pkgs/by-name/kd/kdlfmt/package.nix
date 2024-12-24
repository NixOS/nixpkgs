{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "kdlfmt";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "hougesen";
    repo = "kdlfmt";
    rev = "v${version}";
    hash = "sha256-Eq/m5PnStfZokktgrsYx7e8uWZDB/JgomsrahuL5GYo=";
  };

  cargoHash = "sha256-ay8QO2mHsbfidM9iBHfSdt7JN33T1o87jA/3ZIg1eUw=";

  meta = {
    description = "Formatter for kdl documents";
    homepage = "https://github.com/hougesen/kdlfmt.git";
    changelog = "https://github.com/hougesen/kdlfmt/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airrnot ];
    mainProgram = "kdlfmt";
  };
}
