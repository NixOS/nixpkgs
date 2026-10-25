{
  stdenv,
  lib,
  fetchFromGitHub,
  bison,
  flex,
  openssl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dma";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "corecode";
    repo = "dma";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-rmgEWkV/ZmOcO1J1uTMMO5tJWq8DTyT7ANRjHyWUGNw=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  buildInputs = [
    openssl
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail " -m 2755 -o root -g mail" "" \
      --replace-fail " -m 4754 -o root -g mail" ""
    substituteInPlace local.c \
      --replace-fail "LIBEXEC_PATH" '"/run/wrappers/bin"'
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "Small Mail Transport Agent, designed for home and office use";
    homepage = "https://github.com/corecode/dma";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ aanderse ];
    platforms = lib.platforms.linux;
  };
})
