{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "libsv";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "uael";
    repo = "sv";
    rev = "v${version}";
    sha256 = "sha256-sc7WTRY8XTm5+J+zlS7tGa2f+2d7apj+XHyBafZXXeE=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Public domain cross-platform semantic versioning in C99";
    homepage = "https://github.com/uael/sv";
    license = licenses.unlicense;
    maintainers = [ lib.maintainers.sigmanificient ];
    platforms = platforms.unix;
  };
}
