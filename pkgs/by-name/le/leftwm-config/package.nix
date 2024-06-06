{ stdenv, lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "leftwm-config";
  version = "0-unstable-2024-03-23";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = "leftwm-config";
    rev = "a9f2f21ece3a01d6c36610295ae3163644d3f99e";
    hash = "sha256-wyb/26EyNyBJeTDUvnMxlMiQjaCGBES8t4VteNY1I/A=";
  };

  cargoHash = "sha256-fiB8y4v1gc8d2gvqsgdQ4xHIjzrLxcqp8ybk09tOO8U";

  meta = {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A little satellite utility for LeftWM";
    homepage = "https://github.com/leftwm/leftwm-config";
    maintainers = with lib.maintainers; [ denperidge ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
