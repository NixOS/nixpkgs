{
  stdenv,
  fetchFromGitHub,
  cmake,
  lib,
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

  postPatch = ''
    # Inline https://github.com/ku1ik/stderred/pull/95
    substituteInPlace CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 3.0)' \
      'cmake_minimum_required(VERSION 3.10)'
  '';

  nativeBuildInputs = [
    cmake
  ];

  sourceRoot = "${src.name}/src";

  meta = with lib; {
    description = "Colorize all stderr output that goes to terminal, making it distinguishable from stdout";
    homepage = "https://github.com/sickill/stderred";
    license = licenses.mit;
    maintainers = with maintainers; [ vojta001 ];
    platforms = platforms.unix;
  };
}
