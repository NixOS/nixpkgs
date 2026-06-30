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
  version = "1.10";

  src = fetchFromGitHub {
    owner = "dinhviethoa";
    repo = "libetpan";
    tag = finalAttrs.version;
    hash = "sha256-dG1qsYv9W0l6LLMW+XnKtUunga3IGVxEy34Tnp+K99o=";
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
    hasNoMaintainersButDependents = true;
  };
})
