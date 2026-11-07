{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "leftwm-config";
  version = "0-unstable-2024-03-13";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = "leftwm-config";
    rev = "a9f2f21ece3a01d6c36610295ae3163644d3f99e";
    hash = "sha256-wyb/26EyNyBJeTDUvnMxlMiQjaCGBES8t4VteNY1I/A=";
  };

  cargoHash = "sha256-FiM51ZV61aCFWHyNIudQl1B7X5ov0SXyWIVE4am1Vmw=";

  meta = {
    description = "Little satellite utility for LeftWM";
    homepage = "https://github.com/leftwm/leftwm-config";
    maintainers = with lib.maintainers; [ denperidge ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
