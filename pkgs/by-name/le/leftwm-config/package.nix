{ stdenv, lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "leftwm-config";
  version = "a9f2f21ece3a01d6c36610295ae3163644d3f99e";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = pname;
    rev = version;
    sha256 = "sha256-wyb/26EyNyBJeTDUvnMxlMiQjaCGBES8t4VteNY1I/A=";
  };

  cargoSha256 = "sha256-zHZk7Aa63nJhGI2vhDPwFnjNJ8oy7QJOeBCxV2n7uwg=";

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A little satellite utility for LeftWM";
    homepage = "https://github.com/leftwm/leftwm-config";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      denperidge
    ];
  };
}
