{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "gen";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "gen";
    rev = "1b9e403c92de1b80c1e5eae31f09b93609ad3241";
    sha256 = "sha256-DNMsuN3NVWiGJL+b2Qa0lNCp3q0xm/6yFxNUHNbURmE=";
  };
  cargoHash = "sha256-tSWxKcKbiic+XfD/y51WSdim7T7cb34BSumv8i7m48Y=";
  meta = {
    description = "A flexible tool for generating customizable project templates";
    longDescription = ''
      This extensible project generator allows you to quickly set up new projects with customizable templates.
      Ideal for users who want to automate the creation of project skeletons with personalized settings.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NewDawn0 ];
    platforms = lib.platforms.all;
  };
}
