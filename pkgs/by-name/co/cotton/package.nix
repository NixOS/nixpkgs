{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "cotton";
  version = "0-unstable-2023-09-13";

  src = fetchFromGitHub {
    owner = "danielhuang";
    repo = "cotton";
    rev = "df9d79a4b0bc4b140e87ddd7795924a93775a864";
    sha256 = "sha256-ZMQaVMH8cuOb4PQ19g0pAFAMwP8bR60+eWFhiXk1bYE=";
  };

  cargoHash = "sha256-y162tjxPGZQiYBJxFk4QN9ZqSH8jrqa5Y961Sx2zrRs=";

  meta = with lib; {
    description = "Package manager for JavaScript projects";
    mainProgram = "cotton";
    homepage = "https://github.com/danielhuang/cotton";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      dit7ya
      figsoda
    ];
  };
}
