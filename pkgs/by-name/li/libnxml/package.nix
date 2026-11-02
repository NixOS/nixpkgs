{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnxml";
  version = "0.18.6";

  src = fetchFromGitHub {
    owner = "bakulf";
    repo = "libnxml";
    tag = finalAttrs.version;
    hash = "sha256-PbTTnCS4QnBBVmdri3cIxYl0CVdXM7hImA14P6r5a1k=";
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
