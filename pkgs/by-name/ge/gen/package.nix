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
    rev = "v1.0.0";
    sha256 = lib.fakeHash;
  };
  cargoHash = lib.fakeHash;
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
