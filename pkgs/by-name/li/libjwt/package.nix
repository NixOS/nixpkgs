{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  jansson,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libjwt";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "benmcollins";
    repo = "libjwt";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-0gFMeSW4gfbI6MUctcN8UuKhMDswaT8BzHTV2VuwZzc=";
  };

  buildInputs = [
    jansson
    openssl
  ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = {
    homepage = "https://github.com/benmcollins/libjwt";
    description = "JWT C Library";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ pnotequalnp ];
    platforms = lib.platforms.all;
  };
})
