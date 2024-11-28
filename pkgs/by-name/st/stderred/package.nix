{ stdenv
, fetchFromGitHub
, cmake
, lib
}:

stdenv.mkDerivation rec {
  pname = "stderred";
  version = "unstable-2021-04-28";

  src = fetchFromGitHub {
    owner = "sickill";
    repo = "stderred";
    rev = "b2238f7c72afb89ca9aaa2944d7f4db8141057ea";
    sha256 = "sha256-k/EA327AsRHgUYu7QqSF5yzOyO6h5XcE9Uv4l1VcIPI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  sourceRoot = "${src.name}/src";

  meta = with lib; {
    description = "stderr in red";
    homepage = "https://github.com/sickill/stderred";
    license = licenses.mit;
    maintainers = with maintainers; [ vojta001 ];
    platforms = platforms.unix;
  };
}
