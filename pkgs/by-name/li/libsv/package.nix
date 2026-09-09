{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsv";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "uael";
    repo = "sv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sc7WTRY8XTm5+J+zlS7tGa2f+2d7apj+XHyBafZXXeE=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Public domain cross-platform semantic versioning in C99";
    homepage = "https://github.com/uael/sv";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.sigmanificient ];
    platforms = lib.platforms.unix;
  };
})
