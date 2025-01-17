{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnxml";
  version = "0.18.5";

  src = fetchFromGitHub {
    owner = "bakulf";
    repo = "libnxml";
    tag = finalAttrs.version;
    hash = "sha256-6KI1bsfDgGJ4x8Wv7fcwCKm5AILa3jLnV53JY1g9B+M=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ curl ];

  meta = {
    homepage = "https://github.com/bakulf/libnxml";
    description = "C library for parsing, writing and creating XML 1.0 and 1.1 files or streams";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
