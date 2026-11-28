{
  stdenv,
  lib,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  openssl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libetpan";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "dinhvh";
    repo = "libetpan";
    tag = finalAttrs.version;
    hash = "sha256-4dxL5TrKRhaafwuPvjb7YZ28unO87Es2QlDlJIuTKx0=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
  ];

  buildInputs = [ openssl ];

  configureFlags = [ "CFLAGS=-std=gnu17" ];

  configureScript = "./autogen.sh";

  meta = {
    changelog = "https://github.com/dinhvh/libetpan/releases/tag/${finalAttrs.src.tag}";
    description = "Mail Framework for the C Language";
    homepage = "https://www.etpan.org/libetpan.html";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
