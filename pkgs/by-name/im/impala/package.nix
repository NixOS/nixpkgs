{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "impala";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "impala";
    rev = "v${version}";
    hash = "sha256-NPNzvqnuYXrHCOLN0kZwtzPiKVdl6UFnb/S/XtG+sEY=";
  };

  cargoHash = "sha256-3mRWXUWyMgeaGOFvZXUeZmlD607zCz8a2d3O+MzhhNo=";

  meta = {
    description = "TUI for managing wifi";
    homepage = "https://github.com/pythops/impala";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nydragon ];
  };
}
